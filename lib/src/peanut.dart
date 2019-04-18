import 'dart:async';
import 'dart:io';

import 'package:git/git.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;
// ignore: implementation_imports
import 'package:webdev/src/pubspec.dart';

import 'build_runner.dart';
import 'options.dart';

export 'package:webdev/src/pubspec.dart';

export 'options.dart';
export 'utils.dart' show printError;

Future<Null> run(Options options, {String workingDir}) async {
  workingDir ??= p.current;

  try {
    await checkPubspecLock(
        await PubspecLock.read(p.join(workingDir, 'pubspec.lock')),
        requireBuildWebCompilers: true);
  } on FileSystemException catch (e) {
    throw '${e.message} ${e.path}';
  }

  if (FileSystemEntity.typeSync(p.join(workingDir, options.directory)) ==
      FileSystemEntityType.notFound) {
    stderr.writeln(ansi.yellow.wrap(
        'The `${options.directory}` directory does not exist. '
        'This may cause the build to fail. Try setting the `directory` flag.'));
  }

  final isGitDir = await GitDir.isGitDir(workingDir);

  if (!isGitDir) {
    throw 'Not a git directory: $workingDir';
  }

  final gitDir = await GitDir.fromExisting(workingDir, allowSubdirectory: true);

  // current branch cannot be targetBranch
  final currentBranch = await gitDir.getCurrentBranch();
  if (currentBranch.branchName == options.branch) {
    throw 'Cannot update the current branch `${options.branch}`.';
  }

  final secondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;

  // create a temp dir to dump 'pub build' output to
  final tempDir =
      await Directory.systemTemp.createTemp('peanut.$secondsSinceEpoch.');

  try {
    final ranCommandSummary = await runBuildRunner(tempDir.path,
        options.directory, options.buildConfig, options.release, workingDir);
    final commit = await gitDir.updateBranchWithDirectoryContents(
        options.branch, tempDir.path, options.message);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print('Branch "${options.branch}" was updated '
          'with `$ranCommandSummary` output from `${options.directory}`.');
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}
