/// The peanut library.
library peanut;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:git/git.dart';

Future<Null> run(
    String targetDir, String targetBranch, String commitMessage, String mode) async {
  var current = p.current;

  var isGitDir = await GitDir.isGitDir(current);

  if (!isGitDir) {
    print("Not a git directory: $current");
    exit(1);
  }

  GitDir gitDir = await GitDir.fromExisting(current);

  // current branch cannot be targetBranch

  var currentBranch = await gitDir.getCurrentBranch();

  if (currentBranch.branchName == targetBranch) {
    print("Cannot update the current branch ${targetBranch}");
    exit(1);
  }

  // create a temp dir to dump 'pub build' output to
  Directory tempDir =
      await Directory.systemTemp.createTemp('peanut.$_secondsSinceEpoch.');

  try {
    var args = ['build', '--output', tempDir.path, targetDir, '--mode', mode];

    Process process = await Process.start('pub', args, runInShell: true);

    process.stdout.transform(_lineDecoder).listen((line) {
      stdout.writeln(line);
    });

    process.stderr.transform(_lineDecoder).listen((line) {
      stderr.writeln(line);
    });

    var exitCode = await process.exitCode;

    if (exitCode != 0) {
      throw 'Error running pub ${args.join(' ')}';
    }

    Commit commit = await gitDir.updateBranchWithDirectoryContents(
        targetBranch, p.join(tempDir.path, targetDir), commitMessage);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print('Branch "$targetBranch" was updated '
          'with "pub build" output from "$targetDir".');
    }
  } catch (e, stack) {
    print(e);
    if (e is! String) {
      print(stack);
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}

int _secondsSinceEpoch = new DateTime.now().toUtc().millisecondsSinceEpoch;

final _lineDecoder = SYSTEM_ENCODING.decoder.fuse(const LineSplitter());
