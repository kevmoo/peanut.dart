import 'dart:io';

import 'package:checks/checks.dart';
import 'package:path/path.dart' as p;
import 'package:peanut/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('dartPath returns non-empty executable path', () {
    check(dartPath).isNotEmpty();
  });

  test('flutterPath handles unset or set FLUTTER_ROOT without throwing', () {
    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    final expectedBin = Platform.isWindows ? 'flutter.bat' : 'flutter';
    if (flutterRoot != null && flutterRoot.isNotEmpty) {
      check(flutterPath).equals(p.join(flutterRoot, 'bin', expectedBin));
    } else {
      check(flutterPath).equals(expectedBin);
    }
  });
}
