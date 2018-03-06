import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:git/git.dart';

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

  Process process = await Process.start('pub', args, runInShell: true);

  _getStrings(process.stdout).listen((line) {
    stdout.writeln(line);
  });

  _getStrings(process.stderr).listen((line) {
    stderr.writeln(line);
  });

  var procExitCode = await process.exitCode;

  if (procExitCode != 0) {
    throw 'Error running pub ${args.join(' ')}';
  }
}

Stream<String> _getStrings(Stream<List<int>> std) =>
    const LineSplitter().bind(SYSTEM_ENCODING.decoder.bind(std));
