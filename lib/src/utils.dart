import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;
import 'peanut_exception.dart';

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

final bool isFlutterSdk = (() {
  const depth = 7;
  final components = p.split(Platform.resolvedExecutable);
  if (components.length < depth) {
    return false;
  }

  // Assume that the Flutter SDK is installed in a directory named 'flutter'
  final flutterIndex = components.lastIndexOf('flutter');

  // TODO(kevmoo: This is off on my installation of Flutter.
  // Need to investigate
  return flutterIndex > components.length - depth;
})();

final String flutterPath = p.join(
    _flutterSdkDir, 'bin', Platform.isWindows ? 'flutter.bat' : 'flutter');

/// The path to the root directory of the Flutter SDK.
String _flutterSdkDir = (() {
  assert(isFlutterSdk);
  // The Flutter executable is in
  // "/path/to/flutter/sdk/bin/cache/dart-sdk/bin/dart", so 5 levels up is
  // "/path/to/flutter/sdk".
  var dir = Platform.resolvedExecutable;
  for (var i = 0; i < 5; i++) {
    dir = p.dirname(dir);
  }
  return dir;
})();
