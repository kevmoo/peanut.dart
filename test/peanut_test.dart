@Timeout.factor(4)
library peanut_test;

import 'dart:convert';
import 'dart:io';

import 'package:git/git.dart';
import 'package:path/path.dart' as p;
import 'package:peanut/src/peanut.dart';
import 'package:peanut/src/peanut_exception.dart';
import 'package:peanut/src/version.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

TypeMatcher _treeEntry(String name, String type) => isA<TreeEntry>()
    .having((te) => te.name, 'name', name)
    .having((te) => te.type, 'type', type);

Matcher _throwsPeanutException(message) => throwsA(
    isA<PeanutException>().having((pe) => pe.message, 'message', message));

Future<void> _run({Options options}) =>
    run(workingDir: d.sandbox, options: options);

void main() {
  test('no pub get', () async {
    await _simplePackage();
    await _initGitDir();

    await expectLater(
      _run(),
      _throwsPeanutException(
          'No pubspec.lock file found, please run "pub get" first.'),
    );
  });

  test('not a git dir', () async {
    await _simplePackage();

    await expectLater(
      _run(),
      _throwsPeanutException('Not a git directory: ${d.sandbox}'),
    );
  });

  test('no directories provided', () async {
    await _simplePackage();
    await _initGitDir();

    await expectLater(
      _run(options: const Options(directories: [])),
      _throwsPeanutException('At least one directory must be provided.'),
    );
  });

  test('directory outside working dir', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await expectLater(
      _run(
        options: const Options(directories: ['../temp/silly']),
      ),
      _throwsPeanutException(
        '"../temp/silly" is not in the working directory "${d.sandbox}".',
      ),
    );
  });

  test('directory same as working dir', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await expectLater(
      _run(
        options: Options(directories: [d.sandbox]),
      ),
      _throwsPeanutException(
        '"${d.sandbox}" is the same as the working directory, '
        'which is not allowed.',
      ),
    );
  });

  test('targeting current branch', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await expectLater(
      _run(
        options: const Options(branch: 'main'),
      ),
      _throwsPeanutException(
        'Cannot update the current branch "main".',
      ),
    );
  });

  test('simple integration', () async {
    await _simplePackage();
    await _pubGet();
    final gitDir = await _initGitDir();
    final primaryCommit = await gitDir.showRef();

    await _run();

    expect((await gitDir.branches()).map((br) => br.branchName),
        unorderedEquals(['main', 'gh-pages']));

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef.sha);
    expect(ghCommit.message, '''
Built web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

    await _expectStandardTreeContents(gitDir, ghCommit.treeSha);
  });

  test('1 package, 2 build dirs', () async {
    await _simplePackage(buildDirs: {'example', 'web'});
    await _pubGet();
    final gitDir = await _initGitDir();
    final primaryCommit = await gitDir.showRef();

    await _run(options: const Options(directories: ['example', 'web']));

    expect(
      (await gitDir.branches()).map((br) => br.branchName),
      unorderedEquals(['main', 'gh-pages']),
    );

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef.sha);
    expect(ghCommit.message, '''
Built example, web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

    final treeContents = await gitDir.lsTree(ghCommit.treeSha);

    expect(
      treeContents.map((te) => te.name),
      unorderedEquals(['example', 'web', 'index.html']),
    );

    expect(treeContents, contains(_treeEntry('index.html', 'blob')));

    for (var te in treeContents.where((te) => te.type == 'tree')) {
      await _expectStandardTreeContents(gitDir, te.sha);
    }
  });

  test('2 packages, 2 build dirs', () async {
    const packages = {'pkg1', 'pkg2'};
    for (var pkg in packages) {
      await _simplePackage(
        parent: pkg,
        buildDirs: {'example', 'web'},
      );
      await _pubGet(parent: pkg);
    }

    final gitDir = await _initGitDir();
    final primaryCommit = await gitDir.showRef();

    await _run(
        options: const Options(
      directories: [
        'pkg1/example',
        'pkg1/web',
        'pkg2/example',
        'pkg2/web',
      ],
    ));

    expect((await gitDir.branches()).map((br) => br.branchName),
        unorderedEquals(['main', 'gh-pages']));

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef.sha);
    expect(ghCommit.message, '''
Built pkg1/example, pkg1/web, pkg2/example, pkg2/web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

    final treeContents = await gitDir.lsTree(ghCommit.treeSha);

    expect(
      treeContents.map((te) => te.name),
      unorderedEquals(packages.followedBy(['index.html'])),
    );

    expect(treeContents, contains(_treeEntry('index.html', 'blob')));

    final pkgTreeHashes = treeContents
        .where((te) => te.type == 'tree')
        .map((te) => te.sha)
        .toSet();
    expect(pkgTreeHashes, hasLength(1), reason: 'should be identical');

    final pkgContent = await gitDir.lsTree(pkgTreeHashes.single);
    expect(
      pkgContent.map((te) => te.name),
      unorderedEquals(['example', 'web']),
    );

    for (var te in pkgContent) {
      await _expectStandardTreeContents(gitDir, te.sha);
    }
  }, timeout: const Timeout.factor(2));

  group('post build script', () {
    test('valid', () async {
      const buildDirs = {'example', 'web'};
      await _simplePackage(buildDirs: buildDirs);
      await d.file('post_build.dart', '''
import 'dart:io';
void main(List<String> args) {
  File('\${args[0]}/some_file.txt').writeAsStringSync('some file contents');
  File('\${args[0]}/map.json').writeAsStringSync(args[1]);
}
''').create();

      await _pubGet();
      final gitDir = await _initGitDir();
      final primaryCommit = await gitDir.showRef();

      await _run(
        options: Options(
            directories: buildDirs.toList(),
            postBuildDartScript: 'post_build.dart'),
      );

      expect((await gitDir.branches()).map((br) => br.branchName),
          unorderedEquals(['main', 'gh-pages']));

      final ghBranchRef = await gitDir.branchReference('gh-pages');

      final ghCommit = await gitDir.commitFromRevision(ghBranchRef.sha);
      expect(ghCommit.message, '''
Built example, web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

      final treeContents = await gitDir.lsTree(ghCommit.treeSha);
      expect(
        treeContents,
        unorderedEquals([
          _treeEntry('example', 'tree'),
          _treeEntry('index.html', 'blob'),
          _treeEntry('map.json', 'blob'),
          _treeEntry('some_file.txt', 'blob'),
          _treeEntry('web', 'tree'),
        ]),
      );

      final mapJsonSha =
          treeContents.singleWhere((te) => te.name == 'map.json').sha;

      final result = await gitDir.runCommand(['cat-file', '-p', mapJsonSha]);
      final mapOutput =
          jsonDecode(result.stdout as String) as Map<String, dynamic>;
      expect(mapOutput, Map.fromIterable(buildDirs));
    });

    test('missing', () async {
      await _simplePackage();
      await _pubGet();
      await _initGitDir();

      await expectLater(
        _run(options: const Options(postBuildDartScript: 'post_build.dart')),
        _throwsPeanutException(startsWith(
          'The provided post-build Dart script does not exist '
          'or is not a file.',
        )),
      );
    });

    test('failed', () async {
      await _simplePackage();
      await d.file('post_build.dart', '''
import 'dart:io';
void main() {
  print('sorry!');
  exitCode = 123;
}
''').create();
      await _pubGet();
      await _initGitDir();

      await expectLater(
        _run(options: const Options(postBuildDartScript: 'post_build.dart')),
        _throwsPeanutException(
          allOf(
            startsWith('Error running "'),
            endsWith('\nExit code 123'),
          ),
        ),
      );
    });
  });
}

String _standardTreeContentSha;

Future<void> _expectStandardTreeContents(GitDir gitDir, String treeSha) async {
  if (_standardTreeContentSha == null) {
    final treeContents = await gitDir.lsTree(treeSha);

    try {
      expect(treeContents, hasLength(3));
      expect(
        treeContents,
        contains(
          _treeEntry('example_script.dart.js', 'blob'),
        ),
      );
      expect(
        treeContents,
        contains(
          _treeEntry('index.html', 'blob'),
        ),
      );
      expect(
        treeContents,
        contains(
          _treeEntry('packages', 'tree'),
        ),
      );

      _standardTreeContentSha = treeSha;
    } catch (e) {
      await _logGitTree(gitDir, treeSha);
      rethrow;
    }
  } else {
    expect(
      treeSha,
      _standardTreeContentSha,
      reason: 'Standard directory content should be identical across tests.',
    );
  }
}

Future<void> _pubGet({String parent}) async {
  final proc = await Process.run(
    'pub',
    ['get', '--offline', '--no-precompile'],
    workingDirectory: p.join(d.sandbox, parent),
  );
  expect(
    proc.exitCode,
    0,
    reason: [
      'STDOUT:',
      proc.stdout as String,
      'STDERR:',
      proc.stderr as String,
    ].map((str) => str.trim()).join('\n'),
  );
}

Future<GitDir> _initGitDir() async {
  final gitDir = await GitDir.init(
    d.sandbox,
    allowContent: true,
    initialBranch: 'main',
  );

  await gitDir.runCommand(['add', '.']);
  await gitDir.runCommand(['commit', '-m', 'dummy commit']);

  expect(
    (await gitDir.branches()).map((br) => br.branchName),
    ['main'],
  );
  return gitDir;
}

Future<void> _simplePackage({
  Set<String> buildDirs = const {'web'},
  String parent,
}) async {
  if (parent != null) {
    assert(p.isRelative(parent));
    parent = p.join(d.sandbox, parent);
    await d.dir(parent).create();
  }

  await d.file('pubspec.yaml', r'''
name: peanut_test

environment:
  sdk: '>=2.10.0 <3.0.0'

dev_dependencies:
  build_runner: '>=0.8.10 <2.0.0'
  build_web_compilers: '>=1.0.0 <3.0.0'
''').create(parent);

  await d.file('.gitignore', '.dart_tool/').create(parent);

  for (var buildDir in buildDirs) {
    await d
        .dir(
          buildDir,
          _exampleFiles.entries.map((e) => d.file(e.key, e.value)),
        )
        .create(parent);
  }
}

final _exampleFiles = Map.fromEntries(
  Directory('example')
      .listSync()
      .cast<File>()
      .map((f) => MapEntry(p.basename(f.path), f.readAsStringSync())),
);

Future _logGitTree(GitDir gitDir, String sha, {int depth = 0}) async {
  final treeContents = await gitDir.lsTree(sha);

  for (var te in treeContents) {
    print(' ' * depth + te.name);
    if (te.type == 'tree') {
      await _logGitTree(gitDir, te.sha, depth: depth + 1);
    }
  }
}
