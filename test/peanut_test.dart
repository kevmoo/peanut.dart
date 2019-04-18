import 'dart:io';

import 'package:git/git.dart';
import 'package:peanut/src/options.dart';
import 'package:peanut/src/peanut.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

TypeMatcher _treeEntry(String name, String type) => isA<TreeEntry>()
    .having((te) => te.name, 'name', name)
    .having((te) => te.type, 'type', type);

void main() {
  test('no pub get', () async {
    await _simplePackage();

    await expectLater(
      run(Options(), workingDir: d.sandbox),
      throwsA('Cannot open file ${d.sandbox}/pubspec.lock'),
    );
  });

  test('not a git dir', () async {
    await _simplePackage();

    final proc = await Process.start(
        'pub', ['get', '--offline', '--no-precompile'],
        workingDirectory: d.sandbox);
    expect(await proc.exitCode, 0);

    await expectLater(
      run(Options(), workingDir: d.sandbox),
      throwsA('Not a git directory: ${d.sandbox}'),
    );
  });

  test('integration', () async {
    await _simplePackage();

    final proc = await Process.start(
        'pub', ['get', '--offline', '--no-precompile'],
        workingDirectory: d.sandbox);
    expect(await proc.exitCode, 0);

    final gitDir = await GitDir.init(Directory(d.sandbox), allowContent: true);

    await gitDir.runCommand(['add', '.']);
    await gitDir.runCommand(['commit', '-m', 'dummy commit']);

    expect(await gitDir.getBranchNames(), ['master']);

    await run(Options(message: 'test commit message'), workingDir: d.sandbox);

    expect(
        await gitDir.getBranchNames(), unorderedEquals(['master', 'gh-pages']));

    final ghBranchRef = await gitDir.getBranchReference('gh-pages');

    final ghCommit = await gitDir.getCommit(ghBranchRef.sha);
    expect(ghCommit.message, 'test commit message');

    final treeContents = await gitDir.lsTree(ghCommit.treeSha);
    expect(treeContents, hasLength(2));
    expect(treeContents, contains(_treeEntry('index.html', 'blob')));
    expect(treeContents, contains(_treeEntry('packages', 'tree')));
  }, timeout: const Timeout.factor(2));
}

Future<void> _simplePackage() async {
  await d.file('pubspec.yaml', r'''
name: peanut_test

dev_dependencies:
  build_runner: '>=0.8.10 <2.0.0'
  build_web_compilers: '>=0.3.6 <2.0.0'
''').create();

  await d.dir(
    'web',
    [
      d.file('index.html', '<html><body></body></html>'),
    ],
  ).create();
}
