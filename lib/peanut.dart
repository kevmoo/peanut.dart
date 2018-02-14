import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:git/git.dart';

Future<Null> run(String targetDir, String targetBranch, String commitMessage,
    String mode, bool useBuildRunner) async {
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
    var args = useBuildRunner
        // Build with build_runner.
        // TODO Clean this up when better command line args exist.
        ? [
            'run',
            'build_runner',
            'build',
            '--output',
            tempDir.path,
            // Force build with dart2js instead of dartdevc.
            '--define',
            '"build_web_compilers|entrypoint=compiler=dart2js"',
            // Use checked mode and minify.
            // TODO Add --no-source-maps flag when fix is published.
            '--define',
            '"build_web_compilers|entrypoint=dart2js_args=[\"--checked\", '
                '\"--minify\"]"'
          ]
        // Build with pub.
        : ['build', '--output', tempDir.path, targetDir, '--mode', mode];

    Process process = await Process.start('pub', args, runInShell: true);

    getStrings(process.stdout).listen((line) {
      stdout.writeln(line);
    });

    getStrings(process.stderr).listen((line) {
      stderr.writeln(line);
    });

    var procExitCode = await process.exitCode;

    if (procExitCode != 0) {
      throw 'Error running pub ${args.join(' ')}';
    }

    // TODO Avoid copying input files that appear in the output.
    Commit commit = await gitDir.updateBranchWithDirectoryContents(
        targetBranch, p.join(tempDir.path, targetDir), commitMessage);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      var command = useBuildRunner ? 'pub run build_runner' : 'pub build';
      print('Branch "$targetBranch" was updated '
          'with "$command" output from "$targetDir".');
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}

Stream<String> getStrings(Stream<List<int>> std) =>
    const LineSplitter().bind(SYSTEM_ENCODING.decoder.bind(std));
