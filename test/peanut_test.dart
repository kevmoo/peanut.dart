import 'dart:io';

import 'package:git/git.dart';
import 'package:path/path.dart' as p;
import 'package:peanut/src/peanut.dart';
import 'package:peanut/src/peanut_exception.dart';
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

  test('targetting current branch', () async {
    await _simplePackage();
    await _pubGet();
    await _initGitDir();

    await expectLater(
      _run(
        options: const Options(branch: 'master'),
      ),
      _throwsPeanutException(
        'Cannot update the current branch "master".',
      ),
    );
  });

  test('simple integration', () async {
    await _simplePackage();
    await _pubGet();
    final gitDir = await _initGitDir();
    final masterCommit = await gitDir.showRef();

    await _run();

    expect(
        await gitDir.getBranchNames(), unorderedEquals(['master', 'gh-pages']));

    final ghBranchRef = await gitDir.getBranchReference('gh-pages');

    final ghCommit = await gitDir.getCommit(ghBranchRef.sha);
    expect(ghCommit.message, startsWith('''
Built web

Branch: master
Commit: ${masterCommit.single.sha}'''));

    await _expectStandardTreeContents(gitDir, ghCommit.treeSha);
  }, timeout: const Timeout.factor(2));

  test('1 package, 2 build dirs', () async {
    await _simplePackage(buildDirs: {'example', 'web'});
    await _pubGet();
    final gitDir = await _initGitDir();
    final masterCommit = await gitDir.showRef();

    await _run(options: const Options(directories: ['example', 'web']));

    expect(
        await gitDir.getBranchNames(), unorderedEquals(['master', 'gh-pages']));

    final ghBranchRef = await gitDir.getBranchReference('gh-pages');

    final ghCommit = await gitDir.getCommit(ghBranchRef.sha);
    expect(ghCommit.message, startsWith('''
Built example, web

Branch: master
Commit: ${masterCommit.single.sha}'''));

    final treeContents = await gitDir.lsTree(ghCommit.treeSha);

    expect(
      treeContents.map((te) => te.name),
      unorderedEquals(['example', 'web', 'index.html']),
    );

    expect(treeContents, contains(_treeEntry('index.html', 'blob')));

    for (var te in treeContents.where((te) => te.type == 'tree')) {
      await _expectStandardTreeContents(gitDir, te.sha);
    }
  }, timeout: const Timeout.factor(2));

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
    final masterCommit = await gitDir.showRef();

    await _run(
        options: const Options(
      directories: [
        'pkg1/example',
        'pkg1/web',
        'pkg2/example',
        'pkg2/web',
      ],
    ));

    expect(
        await gitDir.getBranchNames(), unorderedEquals(['master', 'gh-pages']));

    final ghBranchRef = await gitDir.getBranchReference('gh-pages');

    final ghCommit = await gitDir.getCommit(ghBranchRef.sha);
    expect(ghCommit.message, startsWith('''
Built pkg1/example, pkg1/web, pkg2/example, pkg2/web

Branch: master
Commit: ${masterCommit.single.sha}'''));

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
        pkgContent.map((te) => te.name), unorderedEquals(['example', 'web']));

    for (var te in pkgContent) {
      await _expectStandardTreeContents(gitDir, te.sha);
    }
  }, timeout: const Timeout.factor(4));
}

String _standardTreeContentSha;

Future<void> _expectStandardTreeContents(GitDir gitDir, String treeSha) async {
  if (_standardTreeContentSha == null) {
    final treeContents = await gitDir.lsTree(treeSha);

    try {
      expect(treeContents, hasLength(2));
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

      _standardTreeContentSha = treeSha;
    } catch (e) {
      await _logGitTree(gitDir, treeSha);
      rethrow;
    }
  } else {
    expect(
      treeSha,
      _standardTreeContentSha,
      reason: 'Standard directory content should be idential across tests.',
    );
  }
}

Future<void> _pubGet({String parent}) async {
  final proc = await Process.start(
      'pub', ['get', '--offline', '--no-precompile'],
      workingDirectory: p.join(d.sandbox, parent));
  expect(await proc.exitCode, 0);
}

Future<GitDir> _initGitDir() async {
  final gitDir = await GitDir.init(Directory(d.sandbox), allowContent: true);

  await gitDir.runCommand(['add', '.']);
  await gitDir.runCommand(['commit', '-m', 'dummy commit']);

  expect(await gitDir.getBranchNames(), ['master']);
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

dev_dependencies:
  build_runner: '>=0.8.10 <2.0.0'
  build_web_compilers: '>=0.3.6 <2.0.0'
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

final _exampleFiles = Map.fromEntries(Directory('example')
    .listSync()
    .cast<File>()
    .map((f) => MapEntry(p.basename(f.path), f.readAsStringSync())));

Future _logGitTree(GitDir gitDir, String sha, {int depth = 0}) async {
  final treeContents = await gitDir.lsTree(sha);

  for (var te in treeContents) {
    print(' ' * depth + te.name);
    if (te.type == 'tree') {
      await _logGitTree(gitDir, te.sha, depth: depth + 1);
    }
  }
}
