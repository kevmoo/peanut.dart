import 'dart:io';

import 'package:path/path.dart' as p;

void main(List<String> args) {
  final intlPkgPath = p.join('packages', 'intl');
  final intlPackagePath = p.join(args.first, intlPkgPath);

  final dir = Directory(intlPackagePath);

  if (dir.existsSync()) {
    print('Deleting `$intlPackagePath` from output');
    dir.deleteSync(recursive: true);
  }
}
