@Timeout.factor(4)
library;

import 'dart:convert';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:git/git.dart';
import 'package:path/path.dart' as p;
import 'package:peanut/src/peanut.dart';
import 'package:peanut/src/peanut_exception.dart';
import 'package:peanut/src/utils.dart';
import 'package:peanut/src/version.dart';
import 'package:test/scaffolding.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void Function(Subject<TreeEntry>) _treeEntry(String name, String type) =>
    (it) => it
      ..has((te) => te.name, 'name').equals(name)
      ..has((te) => te.type, 'type').equals(type);

Future<void> _run({Options? options}) =>
    run(workingDirectory: d.sandbox, options: options ?? const Options());

void main() {
  test('not a git dir', () async {
    await _simplePackage();

    await check(_run()).throws<PeanutException>(
      (it) => it
          .has((pe) => pe.message, 'message')
          .equals('Not a git directory: ${d.sandbox}'),
    );
  });

  test('no directories provided', () async {
    await _simplePackage();
    await _initGitDir();

    await check(
      _run(options: const Options(directories: [])),
    ).throws<PeanutException>(
      (it) => it
          .has((pe) => pe.message, 'message')
          .equals('At least one directory must be provided.'),
    );
  });

  test('directory outside working dir', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await check(
      _run(options: const Options(directories: ['../temp/silly'])),
    ).throws<PeanutException>(
      (it) => it
          .has((pe) => pe.message, 'message')
          .equals(
            '"../temp/silly" is not in the working directory "${d.sandbox}".',
          ),
    );
  });

  test('directory same as working dir', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await check(
      _run(options: Options(directories: [d.sandbox])),
    ).throws<PeanutException>(
      (it) => it
          .has((pe) => pe.message, 'message')
          .equals(
            '"${d.sandbox}" is the same as the working directory, '
            'which is not allowed.',
          ),
    );
  });

  test('targeting current branch', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await check(
      _run(options: const Options(branch: 'main')),
    ).throws<PeanutException>(
      (it) => it
          .has((pe) => pe.message, 'message')
          .equals('Cannot update the current branch "main".'),
    );
  });

  test('simple integration', () async {
    await _simplePackage();
    await _pubGet();
    final gitDir = await _initGitDir();
    final primaryCommit = await gitDir.showRef();

    await _run();

    check(
      (await gitDir.branches()).map((br) => br.branchName),
    ).unorderedEquals(['main', 'gh-pages']);

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef!.sha);
    check(ghCommit.message).equals('''
Built web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

    await _expectStandardTreeContents(gitDir, ghCommit.treeSha);
  });

  test('integration with version-info', () async {
    await _simplePackage();
    await _pubGet();
    final gitDir = await _initGitDir();
    final primaryCommit = await gitDir.showRef();

    await _run(options: const Options(versionInfo: true));

    check(
      (await gitDir.branches()).map((br) => br.branchName),
    ).unorderedEquals(['main', 'gh-pages']);

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef!.sha);
    check(ghCommit.message).equals('''
Built web

Version: 1.0.0

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

    check(
      (await gitDir.branches()).map((br) => br.branchName),
    ).unorderedEquals(['main', 'gh-pages']);

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef!.sha);
    check(ghCommit.message).equals('''
Built example, web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

    final treeContents = await gitDir.lsTree(ghCommit.treeSha);

    check(
      treeContents.map((te) => te.name),
    ).unorderedEquals(['example', 'web', 'index.html']);

    check(treeContents).any(_treeEntry('index.html', 'blob'));

    for (var te in treeContents.where((te) => te.type == 'tree')) {
      await _expectStandardTreeContents(gitDir, te.sha);
    }
  });

  test('2 packages, 2 build dirs', () async {
    const packages = {'pkg1', 'pkg2'};
    for (var pkg in packages) {
      await _simplePackage(parent: pkg, buildDirs: {'example', 'web'});
      await _pubGet(parent: pkg);
    }

    final gitDir = await _initGitDir();
    final primaryCommit = await gitDir.showRef();

    await _run(
      options: const Options(
        directories: ['pkg1/example', 'pkg1/web', 'pkg2/example', 'pkg2/web'],
      ),
    );

    check(
      (await gitDir.branches()).map((br) => br.branchName),
    ).unorderedEquals(['main', 'gh-pages']);

    final ghBranchRef = await gitDir.branchReference('gh-pages');

    final ghCommit = await gitDir.commitFromRevision(ghBranchRef!.sha);
    check(ghCommit.message).equals('''
Built pkg1/example, pkg1/web, pkg2/example, pkg2/web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

    final treeContents = await gitDir.lsTree(ghCommit.treeSha);

    check(
      treeContents.map((te) => te.name),
    ).unorderedEquals(packages.followedBy(['index.html']));

    check(treeContents).any(_treeEntry('index.html', 'blob'));

    final pkgTreeHashes = treeContents
        .where((te) => te.type == 'tree')
        .map((te) => te.sha)
        .toSet();
    check(because: 'should be identical', pkgTreeHashes).length.equals(1);

    final pkgContent = await gitDir.lsTree(pkgTreeHashes.single);
    check(pkgContent.map((te) => te.name)).unorderedEquals(['example', 'web']);

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
          postBuildDartScript: 'post_build.dart',
        ),
      );

      check(
        (await gitDir.branches()).map((br) => br.branchName),
      ).unorderedEquals(['main', 'gh-pages']);

      final ghBranchRef = await gitDir.branchReference('gh-pages');

      final ghCommit = await gitDir.commitFromRevision(ghBranchRef!.sha);
      check(ghCommit.message).equals('''
Built example, web

Branch: main
Commit: ${primaryCommit.single.sha}

package:peanut $packageVersion''');

      final treeContents = await gitDir.lsTree(ghCommit.treeSha);
      check(treeContents).unorderedMatches([
        _treeEntry('example', 'tree'),
        _treeEntry('index.html', 'blob'),
        _treeEntry('map.json', 'blob'),
        _treeEntry('some_file.txt', 'blob'),
        _treeEntry('web', 'tree'),
      ]);

      final mapJsonSha = treeContents
          .singleWhere((te) => te.name == 'map.json')
          .sha;

      final result = await gitDir.runCommand(['cat-file', '-p', mapJsonSha]);
      final mapOutput =
          jsonDecode(result.stdout as String) as Map<String, dynamic>;
      check(mapOutput).deepEquals(Map<String, dynamic>.fromIterable(buildDirs));
    });

    test('missing', () async {
      await _simplePackage();
      await _pubGet();
      await _initGitDir();

      await check(
        _run(options: const Options(postBuildDartScript: 'post_build.dart')),
      ).throws<PeanutException>(
        (it) => it
            .has((pe) => pe.message, 'message')
            .startsWith(
              'The provided post-build Dart script does not exist or '
              'is not a file.',
            ),
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

      await check(
        _run(options: const Options(postBuildDartScript: 'post_build.dart')),
      ).throws<PeanutException>(
        (it) => it.has((pe) => pe.message, 'message')
          ..startsWith('Error running "')
          ..endsWith('\nExit code 123'),
      );
    });
  });
}

String? _standardTreeContentSha;

Future<void> _expectStandardTreeContents(GitDir gitDir, String treeSha) async {
  if (_standardTreeContentSha == null) {
    final treeContents = await gitDir.lsTree(treeSha);

    try {
      check(treeContents).length.equals(2);
      check(treeContents).any(_treeEntry('example_script.dart.js', 'blob'));
      check(treeContents).any(_treeEntry('index.html', 'blob'));

      _standardTreeContentSha = treeSha;
    } catch (e) {
      await _logGitTree(gitDir, treeSha);
      rethrow;
    }
  } else {
    check(
      because: 'Standard directory content should be identical across tests.',
      treeSha,
    ).equals(_standardTreeContentSha!);
  }
}

Future<void> _pubGet({String? parent}) async {
  final proc = await Process.run(dartPath, [
    'pub',
    'get',
    '--offline',
    '--no-precompile',
  ], workingDirectory: p.join(d.sandbox, parent));
  check(
    because: [
      'STDOUT:',
      proc.stdout as String,
      'STDERR:',
      proc.stderr as String,
    ].map((str) => str.trim()).join('\n'),
    proc.exitCode,
  ).equals(0);
}

Future<GitDir> _initGitDir() async {
  final gitDir = await GitDir.init(
    d.sandbox,
    allowContent: true,
    initialBranch: 'main',
  );

  await gitDir.runCommand(['add', '.']);
  await gitDir.runCommand(['commit', '-m', 'dummy commit']);

  check(
    (await gitDir.branches()).map((br) => br.branchName),
  ).deepEquals(['main']);
  return gitDir;
}

Future<void> _simplePackage({
  Set<String> buildDirs = const {'web'},
  String? parent,
}) async {
  if (parent != null) {
    assert(p.isRelative(parent));
    parent = p.join(d.sandbox, parent);
    await d.dir(parent).create();
  }

  await d
      .file('pubspec.yaml', r'''
name: peanut_test
version: 1.0.0

environment:
  sdk: ^3.7.0

dev_dependencies:
  build_runner: ^2.0.0
  build_web_compilers: '>=3.0.0 <5.0.0'
''')
      .create(parent);

  await d.file('.gitignore', '.dart_tool/').create(parent);

  for (var buildDir in buildDirs) {
    await d
        .dir(buildDir, _exampleFiles.entries.map((e) => d.file(e.key, e.value)))
        .create(parent);
  }
}

final _exampleFiles = Map.fromEntries(
  Directory('example').listSync().cast<File>().map(
    (f) => MapEntry(p.basename(f.path), f.readAsStringSync()),
  ),
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
