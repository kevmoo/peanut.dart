import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart' as ansi;
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import 'peanut_exception.dart';

void printError(Object? object) => print(ansi.red.wrap(object.toString()));

Future runProcess(
  String proc,
  List<String> args, {
  String? workingDirectory,
}) async {
  final process = await Process.start(
    proc,
    args,
    runInShell: true,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
  );

  final procExitCode = await process.exitCode;

  if (procExitCode != 0) {
    throw PeanutException(
      'Error running "$proc ${args.join(' ')}"\n'
      'Exit code $procExitCode',
    );
  }
}

String get dartPath => Platform.resolvedExecutable;

final String flutterPath = p.join(
  _flutterSdkDir,
  'bin',
  Platform.isWindows ? 'flutter.bat' : 'flutter',
);

/// The path to the root directory of the Flutter SDK.
final String _flutterSdkDir = Platform.environment['FLUTTER_ROOT']!;

void checkValidOptions(String name, Set<String> config) {
  if (config.isNotEmpty) {
    throw PeanutException('''
The follow options are not supported with a $name build:
 - ${config.join('\n - ')}''', exitCode: ExitCode.usage.code);
  }
}
