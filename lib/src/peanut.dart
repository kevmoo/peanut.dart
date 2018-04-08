import 'dart:async';
import 'dart:io';

import 'package:git/git.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;

import 'build_runner.dart';
import 'enums.dart';
import 'pub_build.dart';

export 'enums.dart';
export 'options.dart';
export 'utils.dart' show printError;

Future<Null> run(String targetDir, String targetBranch, String commitMessage,
    BuildTool buildTool,
    {PubBuildMode pubBuildMode, String buildRunnerConfig}) async {
  var current = p.current;

  if (FileSystemEntity.typeSync(p.join(current, targetDir)) ==
      FileSystemEntityType.NOT_FOUND) {
    stderr.writeln(ansi.yellow.wrap(
        'The `$targetDir` directory does not exist. '
        'This may cause the build to fail. Try setting the `directory` flag.'));
  }

  var isGitDir = await GitDir.isGitDir(current);

  if (!isGitDir) {
    throw 'Not a git directory: $current';
  }

  GitDir gitDir = await GitDir.fromExisting(current, allowSubdirectory: true);

  // current branch cannot be targetBranch

  var currentBranch = await gitDir.getCurrentBranch();

  if (currentBranch.branchName == targetBranch) {
    throw 'Cannot update the current branch $targetBranch';
  }

  var secondsSinceEpoch = new DateTime.now().toUtc().millisecondsSinceEpoch;

  // create a temp dir to dump 'pub build' output to
  var tempDir =
      await Directory.systemTemp.createTemp('peanut.$secondsSinceEpoch.');

  Future<String> runCommand() async {
    switch (buildTool) {
      case BuildTool.pub:
        assert(buildRunnerConfig == null);
        return runPubBuild(tempDir, targetDir, pubBuildMode);
      case BuildTool.build:
        assert(pubBuildMode == null);
        return runBuildRunner(tempDir.path, targetDir, buildRunnerConfig);
    }

    throw new UnsupportedError('Should never get here...');
  }

  try {
    var ranCommandSummary = await runCommand();
    var commit = await gitDir.updateBranchWithDirectoryContents(
        targetBranch, p.join(tempDir.path, targetDir), commitMessage);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print('Branch "$targetBranch" was updated '
          'with `$ranCommandSummary` output from `$targetDir`.');
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}
