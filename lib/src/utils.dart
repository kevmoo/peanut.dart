import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;
import 'package:peanut/src/peanut_exception.dart';

void printError(Object object) => print(ansi.red.wrap(object.toString()));

Future runProcess(String proc, List<String> args,
    {String workingDirectory}) async {
  final process = await Process.start(proc, args,
      runInShell: true,
      workingDirectory: workingDirectory,
      mode: ProcessStartMode.inheritStdio);

  final procExitCode = await process.exitCode;

  if (procExitCode != 0) {
    throw PeanutException('Error running "$proc ${args.join(' ')}"\n'
        'Exit code $procExitCode');
  }
}

final String dartPath = p.join(_sdkDir, 'bin', 'dart');

final String pubPath =
    p.join(_sdkDir, 'bin', Platform.isWindows ? 'pub.bat' : 'pub');

/// The path to the root directory of the SDK.
final String _sdkDir = (() {
  // The Dart executable is in "/path/to/sdk/bin/dart", so two levels up is
  // "/path/to/sdk".
  final aboveExecutable = p.dirname(p.dirname(Platform.resolvedExecutable));
  assert(FileSystemEntity.isFileSync(p.join(aboveExecutable, 'version')));
  return aboveExecutable;
})();
