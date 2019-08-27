import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;

import 'options.dart';
import 'utils.dart';

Future<void> runFlutterBuild(
  String pkgDirectory,
  String outputDir,
  Options options,
) async {
  final args = <String>[
    'build',
    'web',
  ];

  final prettyArgList = args.toList()..insert(0, 'flutter');
  final prettyArgs = prettyArgList.join(' ');

  print(ansi.styleBold.wrap('''
$_commandPrefix$prettyArgs
'''));
  await runProcess(flutterPath, args, workingDirectory: pkgDirectory);
  final sourceDir = p.absolute('build/web');
  await copyFilesRecursive(sourceDir, outputDir);
}

Future copyFilesRecursive(String srcDir, String destDir) async {
  final parent = Directory(srcDir);
  await for (var entity in parent.list(recursive: true)) {
    final relativePath = p.relative(entity.path, from: parent.path);
    final newPath = p.join(destDir, relativePath);
    if (entity is File) {
      await entity.copy(newPath);
    } else if (entity is Directory) {
      final newPathUri = Uri.parse(newPath);
      final dir = Directory.fromUri(newPathUri);
      await dir.create(recursive: true);
      assert(await dir.exists());
    }
  }
}

const _commandPrefix = 'Command:     ';
