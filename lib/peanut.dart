import 'dart:async';
import 'dart:io';

import 'package:git/git.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

Future<Null> run(String targetDir, String targetBranch, String commitMessage,
    String mode) async {
  var current = p.current;

  var isGitDir = await GitDir.isGitDir(current);

  if (!isGitDir) {
    throw 'Not a git directory: $current';
  }

  GitDir gitDir = await GitDir.fromExisting(current);

  // current branch cannot be targetBranch

  var currentBranch = await gitDir.getCurrentBranch();

  if (currentBranch.branchName == targetBranch) {
    throw 'Cannot update the current branch ${targetBranch}';
  }

  var secondsSinceEpoch = new DateTime.now().toUtc().millisecondsSinceEpoch;

  // create a temp dir to dump 'pub build' output to
  Directory tempDir =
      await Directory.systemTemp.createTemp('peanut.$secondsSinceEpoch.');

  try {
    await _runPub(tempDir, targetDir, mode);

    Commit commit = await gitDir.updateBranchWithDirectoryContents(
        targetBranch, p.join(tempDir.path, targetDir), commitMessage);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print('Branch "$targetBranch" was updated '
          'with "pub build" output from "$targetDir".');
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}

Future _runPub(Directory tempDir, String targetDir, String mode) async {
  var args = ['build', '--output', tempDir.path, targetDir, '--mode', mode];

  var manager = new ProcessManager();

  var process = await manager.spawn('pub', args, runInShell: true);

  var procExitCode = await process.exitCode;

  if (procExitCode != 0) {
    throw 'Error running pub ${args.join(' ')}';
  }
}
