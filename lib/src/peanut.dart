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

Future<Null> run(Options options) async {
  await checkPubspecLock(await PubspecLock.read(),
      requireBuildWebCompilers: true);

  var current = p.current;

  if (FileSystemEntity.typeSync(p.join(current, options.directory)) ==
      FileSystemEntityType.notFound) {
    stderr.writeln(ansi.yellow.wrap(
        'The `${options.directory}` directory does not exist. '
        'This may cause the build to fail. Try setting the `directory` flag.'));
  }

  var isGitDir = await GitDir.isGitDir(current);

  if (!isGitDir) {
    throw 'Not a git directory: $current';
  }

  var gitDir = await GitDir.fromExisting(current, allowSubdirectory: true);

  // current branch cannot be targetBranch
  var currentBranch = await gitDir.getCurrentBranch();
  if (currentBranch.branchName == options.branch) {
    throw 'Cannot update the current branch `${options.branch}`.';
  }

  var secondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;

  // create a temp dir to dump 'pub build' output to
  var tempDir =
      await Directory.systemTemp.createTemp('peanut.$secondsSinceEpoch.');

  try {
    var ranCommandSummary = await runBuildRunner(
        tempDir.path, options.directory, options.buildConfig, options.release);
    var commit = await gitDir.updateBranchWithDirectoryContents(
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
