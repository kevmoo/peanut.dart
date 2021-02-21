import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart' as ansi;
import 'package:meta/meta.dart';
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
  final components = p.split(Platform.resolvedExecutable);
  return isFlutterSdkHeuristic(components);
})();

@visibleForTesting
bool isFlutterSdkHeuristic(List<String> path) {
  // This represents the directory depth from /path/to/flutter to
  // /path/to/flutter/sdk/bin/cache/dart-sdk/bin/dart.
  const depth = 7;

  if (path.length < depth) {
    return false;
  }

  // Assume that the Flutter SDK is installed in a directory named 'flutter'
  final flutterIndex = path.lastIndexOf('flutter');

  if (flutterIndex > path.length - depth) {
    return true;
  }

  // If no 'flutter' is found, try FVM to support that version management
  // package. FVM places Flutter SDK in `~/fvm/versions/**`.
  final fvmIndex = path.lastIndexOf('fvm');

  // fvm puts another 2 levels to the depth, with something like
  // /path/to/fvm/versions/stable.
  const fvmDepth = depth + 2;

  if (fvmIndex > path.length - fvmDepth) {
    final versionsIndex = path.indexOf('versions', fvmIndex);
    if (versionsIndex == fvmIndex + 1) {
      // Path contains `fvm/versions`.
      return true;
    }
  }

  // No evidence of running from Flutter SDK.
  return false;
}

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
