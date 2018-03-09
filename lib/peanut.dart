import 'dart:async';
import 'dart:io';

import 'package:git/git.dart';
import 'package:glob/glob.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;

const _usePub = 'pub';
const _useBuild = 'build';

const buildToolOptions = const [_usePub, _useBuild];

void printError(Object object) =>
    stderr.writeln(ansi.red.wrap(object.toString()));

Future<Null> run(String targetDir, String targetBranch, String commitMessage,
    String buildTool,
    {String pubBuildMode, String buildRunnerConfig}) async {
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

  GitDir gitDir = await GitDir.fromExisting(current);

  // current branch cannot be targetBranch

  var currentBranch = await gitDir.getCurrentBranch();

  if (currentBranch.branchName == targetBranch) {
    throw 'Cannot update the current branch $targetBranch';
  }

  var secondsSinceEpoch = new DateTime.now().toUtc().millisecondsSinceEpoch;

  // create a temp dir to dump 'pub build' output to
  var tempDir =
      await Directory.systemTemp.createTemp('peanut.$secondsSinceEpoch.');

  try {
    String command;
    switch (buildTool) {
      case _usePub:
        assert(buildRunnerConfig == null);
        command = await _runPub(tempDir, targetDir, pubBuildMode);
        break;
      case _useBuild:
        assert(pubBuildMode == null);
        command = await _runBuild(tempDir.path, targetDir, buildRunnerConfig);
        break;
      default:
        throw new UnsupportedError(
            'build-tool `$buildTool` is not implemented.');
    }

    Commit commit = await gitDir.updateBranchWithDirectoryContents(
        targetBranch, p.join(tempDir.path, targetDir), commitMessage);

    if (commit == null) {
      print('There was no change in branch. No commit created.');
    } else {
      print('Branch "$targetBranch" was updated '
          'with `$command` output from `$targetDir`.');
    }
  } finally {
    await tempDir.delete(recursive: true);
  }
}

Future<String> _runBuild(
    String tempDir, String targetDir, String config) async {
  if (Platform.isWindows) {
    printError('Currently uses Unix shell commands `cp` and `mkdir`.'
        ' Will likely fail on Windows.'
        ' See https://github.com/kevmoo/peanut.dart/issues/11');
  }

  var args = ['run', 'build_runner', 'build', '--output', tempDir];

  if (config == null) {
    args.addAll([
      // Force build with dart2js instead of dartdevc.
      '--define',
      'build_web_compilers|entrypoint=compiler=dart2js',
      // Match `pub build` defaults for dart2js.
      '--define',
      'build_web_compilers|entrypoint=dart2js_args=[\"--minify\",\"--no-source-maps\"]',
    ]);
  } else {
    args.addAll(['--config', config]);
  }

  await _runProcess('pub', args, workingDirectory: p.current);

  // Verify `$tempDir/$targetDir` exists
  var contentPath = p.join(tempDir, targetDir);
  if (!FileSystemEntity.isDirectorySync(contentPath)) {
    throw new StateError('Expected directory `$contentPath` was not created.');
  }

  var badFileGlob = new Glob('{.packages,**.dart,**.module}');

  var packagesSymlinkPath = p.join(contentPath, 'packages');
  switch (FileSystemEntity.typeSync(packagesSymlinkPath, followLinks: false)) {
    case FileSystemEntityType.NOT_FOUND:
      // no-op –nothing to do
      break;
    case FileSystemEntityType.LINK:
      var packagesLink = new Link(packagesSymlinkPath);
      assert(packagesLink.existsSync());
      var packagesDirPath = packagesLink.targetSync();
      assert(p.isRelative(packagesDirPath));
      packagesDirPath = p.normalize(p.join(contentPath, packagesDirPath));
      assert(FileSystemEntity.isDirectorySync(packagesDirPath));
      assert(p.isWithin(tempDir, packagesDirPath));

      packagesLink.deleteSync();

      var firstExtraFile = true;
      var initialFiles = new Directory(contentPath)
          .listSync(recursive: true, followLinks: false);
      // TODO: use whereType when github.com/dart-lang/sdk/issues/32463 is fixed
      for (var file in initialFiles.where((i) => i is File)) {
        var relativePath = p.relative(file.path, from: contentPath);

        if (badFileGlob.matches(relativePath)) {
          if (firstExtraFile) {
            print('Deleting extra files from output directory:');
            firstExtraFile = false;
          }
          file.deleteSync();
          print('  $relativePath');
        }
      }

      var packagesDir = new Directory(packagesDirPath);

      print('Populating contents...');

      await for (var item in packagesDir.list(recursive: true)) {
        if (item is File) {
          var relativePath = p.relative(item.path, from: tempDir);

          if (badFileGlob.matches(relativePath)) {
            continue;
          }

          if (p.isWithin('packages/\$sdk', relativePath)) {
            // TODO: required for DDC build – need to detect!
            continue;
          }

          var destinationPath = p.join(contentPath, relativePath);

          if (FileSystemEntity.typeSync(p.dirname(destinationPath),
                  followLinks: false) ==
              FileSystemEntityType.NOT_FOUND) {
            await _runProcess('mkdir', ['-p', p.dirname(destinationPath)]);
          }

          stdout.write('.');
          await _runProcess('cp', ['-n', item.path, destinationPath]);
        }
      }
      print('');

      break;
    default:
      throw new StateError('Not sure what to do here...');
  }

  return args.join(' ');
}

Future _runProcess(String proc, List<String> args,
    {String workingDirectory}) async {
  var process = await Process.start(proc, args,
      runInShell: true,
      workingDirectory: workingDirectory,
      mode: ProcessStartMode.INHERIT_STDIO);

  var procExitCode = await process.exitCode;

  if (procExitCode != 0) {
    throw 'Error running `$proc ${args.join(' ')}`.';
  }
}

Future<String> _runPub(Directory tempDir, String targetDir, String mode) async {
  var args = ['build', '--output', tempDir.path, targetDir, '--mode', mode];

  await _runProcess('pub', args);

  return 'pub build';
}
