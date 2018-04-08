import 'dart:async';
import 'dart:io';

import 'enums.dart';
import 'utils.dart';

Future<String> runPubBuild(
    Directory tempDir, String targetDir, PubBuildMode mode) async {
  var args = [
    'build',
    '--output',
    tempDir.path,
    targetDir,
    '--mode',
    mode.toString().split('.')[1]
  ];

  await runProcess(pubPath, args);

  return 'pub build';
}
