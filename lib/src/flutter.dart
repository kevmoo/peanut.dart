import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;

import 'options.dart';
import 'peanut_exception.dart';
import 'utils.dart';

Future<void> runFlutterBuild(
  String pkgDirectory,
  Map<String, String> targets,
  Options options,
) async {
  if (targets.entries.length != 1) {
    throw PeanutException('only 1 target (web) is supported for Flutter apps');
  }

  final args = <String>[
    'build',
    'web',
    if (options.canvasKit) ...['--web-renderer', 'canvaskit'],
    options.release ? '--release' : '--profile',
  ];

  // Print the command to the console
  final prettyArgList = args.toList()..insert(0, 'flutter');
  final prettyArgs = prettyArgList.join(' ');
  print(ansi.styleBold.wrap('''
$_commandPrefix$prettyArgs
'''));

  // Build the app
  await runProcess(flutterPath, args, workingDirectory: pkgDirectory);

  // Create the subdirectory in the temp directory to copy the files to.
  final outputDir = targets.values.first;
  await Directory(outputDir).create(recursive: true);

  // Copy the files
  final sourceDir = p.absolute('$pkgDirectory/build/web');
  await _copyFilesRecursive(sourceDir, outputDir);

  // Delete the build/ directory created from running `flutter build web`
  await Directory(sourceDir).delete(recursive: true);
}

Future<void> _copyFilesRecursive(String srcDir, String destDir) async {
  final parent = Directory(srcDir);
  await for (var entity in parent.list(recursive: true)) {
    final relativePath = p.relative(entity.path, from: parent.path);
    final newPath = p.join(destDir, relativePath);
    if (entity is File) {
      await entity.copy(newPath);
    } else if (entity is Directory) {
      final newPathUri = Uri.file(newPath);
      final dir = Directory.fromUri(newPathUri);
      await dir.create(recursive: true);
      assert(await dir.exists());
    }
  }
}

const _commandPrefix = 'Command:     ';
