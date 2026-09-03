import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_util.dart' as cli_util;
import 'package:io/ansi.dart' as ansi;
import 'package:io/io.dart';
import 'package:path/path.dart' as p;
import 'package:stack_trace/stack_trace.dart';

import 'peanut_exception.dart';

void printError(Object? object) {
  if (object is StackTrace) {
    object = Trace.from(object);
  }
  print(ansi.red.wrap(object.toString()));
}

Future<void> runProcess(
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

String get dartPath => cli_util.dartExecutable ?? 'dart';

String get flutterPath {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final flutterBin = Platform.isWindows ? 'flutter.bat' : 'flutter';
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return p.join(flutterRoot, 'bin', flutterBin);
  }
  return flutterBin;
}

void checkValidOptions(String name, Set<String> config) {
  if (config.isNotEmpty) {
    throw PeanutException('''
The follow options are not supported with a $name build:
 - ${config.join('\n - ')}''', exitCode: ExitCode.usage.code);
  }
}
