import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:git/git.dart';

const _targetBranch = 'gh-pages';
const _targetDir = 'web';

main() async {
  var current = p.current;

  var isGitDir = await GitDir.isGitDir(current);

  if (!isGitDir) {
    print("Not a git directory: $current");
    exit(1);
  }

  GitDir gitDir = await GitDir.fromExisting(current);

  // current branch cannot be targetBranch

  var currentBranch = await gitDir.getCurrentBranch();

  if (currentBranch.branchName == _targetBranch) {
    print("Cannot update the current branch ${_targetBranch}");
    exit(1);
  }

  // create a temp dir to dump 'pub build' output to
  Directory tempDir =
      await Directory.systemTemp.createTemp('peanut.$_secondsSinceEpoch.');

  try {
    var msg = 'building!';

    var args = ['build', '--output', tempDir.path, _targetDir];

    Process process = await Process.start('pub', args);

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
        _targetBranch, p.join(tempDir.path, _targetDir), msg);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print(commit.content);
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
