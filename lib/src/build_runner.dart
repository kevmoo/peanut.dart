import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import 'utils.dart';

Future<String> runBuildRunner(
  String tempDir,
  String pkgDirectory,
  Map<String, String> targets,
  String config,
  bool release,
) async {
  final targetsValue = targets.entries
      .map((e) => '${e.key}:${p.join(tempDir, e.value)}')
      .join(',');

  final args = [
    'run',
    'build_runner',
    'build',
    '--output',
    targetsValue,
    release ? '--release' : '--no-release'
  ];

  if (config != null) {
    args.addAll(['--config', config]);
  }

  await runProcess(pubPath, args, workingDirectory: pkgDirectory);

  var deleteCount = 0;

  for (var buildDir in targets.values.map((dir) => p.join(tempDir, dir))) {
    for (var file in Directory(buildDir)
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()) {
      final relativePath = p.relative(file.path, from: buildDir);

      if (_badFileGlob.matches(relativePath)) {
        if (deleteCount == 0) {
          stdout.write('Deleting extra files from output directory');
        }
        stdout.write('.');
        file.deleteSync();
        deleteCount++;
      }
    }
  }

  if (deleteCount > 0) {
    print('\nDeleted count: $deleteCount\n'
        '  Matching ${_globItems.map((e) => '"$e"').join(', ')}');
  }

  return args.join(' ');
}

const _globItems = {
  '**.dart',
  '**.dart.js.deps',
  '**.dart.js.tar.gz',
  '**.md',
  '**.module',
  '**.ng_placeholder', // Generated by pkg:angular
  '**.yaml',
  '.build.manifest',
  '.packages',
  'packages/\$sdk/**',
  'packages/analyzer/**',
  'packages/build_runner/**',
  'packages/build_web_compilers/**',
  'packages/node_preamble/**',
  'packages/package_resolver/**',
  'packages/test/**',
};

final _badFileGlob = Glob('{${_globItems.join(',')}}');