import 'dart:async';
import 'dart:io';

import 'package:git/git.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;

import 'build_runner.dart';
import 'helpers.dart';
import 'options.dart';
import 'peanut_exception.dart';
import 'webdev.dart';

export 'options.dart';
export 'utils.dart' show printError;
export 'webdev.dart' show PackageException;

Future<void> run({Options options, String workingDir}) async {
  options ??= const Options();
  workingDir ??= p.current;

  final isGitDir = await GitDir.isGitDir(workingDir);

  if (!isGitDir) {
    throw PeanutException('Not a git directory: $workingDir');
  }

  final gitDir = await GitDir.fromExisting(workingDir, allowSubdirectory: true);

  // current branch cannot be targetBranch
  final currentBranch = await gitDir.getCurrentBranch();

  if (currentBranch.branchName == options.branch) {
    throw PeanutException(
        'Cannot update the current branch "${options.branch}".');
  }

  if (options.directories.isEmpty) {
    throw PeanutException('At least one directory must be provided.');
  }

  // key: package dir; value: all dirs to build within that package
  final targetDirs = targetDirectories(workingDir, options.directories);

  for (var dir in options.directories) {
    final fullPath = pkgNormalize(workingDir, dir);

    if (p.equals(workingDir, dir)) {
      throw PeanutException(
          '"$dir" is the same as the working directory, which is not allowed.');
    }

    if (!p.isWithin(workingDir, fullPath)) {
      throw PeanutException(
          '"$dir" is not in the working directory "$workingDir".');
    }
  }

  for (var entry in targetDirs.entries) {
    final entryDir = pkgNormalize(workingDir, entry.key);
    try {
      await checkPubspecLock(entryDir);
    } on FileSystemException catch (e) {
      throw PeanutException('${e.message} ${e.path}');
    }

    for (var dir in entry.value) {
      final buildDirPath = p.join(entryDir, dir);
      if (FileSystemEntity.typeSync(buildDirPath) ==
          FileSystemEntityType.notFound) {
        stderr.writeln(
          ansi.yellow.wrap(
            'The `$buildDirPath` directory does not exist. This may cause the '
            'build to fail. Try setting the `directory` flag.',
          ),
        );
      }
    }
  }

  final secondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;

  var message = options.message;

  if (message == defaultMessage) {
    message = 'Built ${options.directories.join(', ')}';
  }

  final outputDirMap = outputDirectoryMap(targetDirs);

  // create a temp dir to dump 'pub build' output to
  final tempDir =
      await Directory.systemTemp.createTemp('peanut.$secondsSinceEpoch.');

  try {
    for (var sourcePkg in targetDirs.keys) {
      final targets = Map<String, String>.fromEntries(outputDirMap.entries
          .where((e) => p.isWithin(sourcePkg, e.key))
          .map((e) =>
              MapEntry(p.split(e.key).last, p.join(tempDir.path, e.value))));

      await runBuildRunner(
        p.join(workingDir, sourcePkg),
        targets,
        options.buildConfig,
        options.release,
      );
    }

    if (options.sourceBranchInfo) {
      final currentBranch = await gitDir.getCurrentBranch();
      var commitInfo = currentBranch.sha;
      if (!await gitDir.isWorkingTreeClean()) {
        commitInfo = '$commitInfo (dirty)';
      }
      message = '''
$message

Branch: ${currentBranch.branchName}
Commit: $commitInfo''';
    }

    final commit = await gitDir.updateBranchWithDirectoryContents(
        options.branch, tempDir.path, message);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print('Branch "${options.branch}" was updated with output from '
          '`${options.directories}`.');
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}
