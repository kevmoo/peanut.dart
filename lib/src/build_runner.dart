import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;

import 'options.dart';
import 'utils.dart';

Future<void> runBuildRunner(
  String pkgDirectory,
  Map<String, String> targets,
  Options options,
) async {
  final targetsValue = targets.entries
      .map((e) => '${e.key}:${e.value}')
      .join(',');

  final extraArgs = options.splitExtraArgs();

  final extraArgsList = extraArgs == null ? null : [extraArgs];

  final args = <List<String>>[
    [
      'dart',
      'run',
      'build_runner',
      'build',
      options.release ? '--release' : '--no-release',
    ],
    if (options.buildConfig != null) ['--config', options.buildConfig!],
    if (options.builderOptions != null)
      for (var option in options.builderOptions!.entries)
        for (var optionEntry in option.value.entries)
          [
            '--define',
            _defineValue(option.key, optionEntry.key, optionEntry.value),
          ],
    ...?extraArgsList,
    ['--output', targetsValue],
  ];

  final prettyArgs = args
      .map((list) => list.join(' '))
      .join(' \\\n$_argsExtraLinePrefix');

  print(
    ansi.styleBold.wrap('''
$_commandPrefix$prettyArgs
'''),
  );

  if (options.dryRun) {
    return;
  }

  final flatArgs =
      args
          .expand((list) => list)
          .skip(1) // skip `dart`
          .toList();

  await runProcess(dartPath, flatArgs, workingDirectory: pkgDirectory);

  var deleteCount = 0;

  for (var buildDir in targets.values) {
    for (var file
        in Directory(
          buildDir,
        ).listSync(recursive: true, followLinks: false).whereType<File>()) {
      final relativePath = p.relative(file.path, from: buildDir);

      if (_badFileGlob.matches(relativePath)) {
        if (deleteCount == 0) {
          print('');
          stdout.write(
            ansi.styleBold.wrap('Deleting extra files from output directory'),
          );
          if (options.verbose) {
            print('');
          }
        }
        if (options.verbose) {
          print('  $relativePath');
        } else {
          stdout.write('.');
        }
        file.deleteSync();
        deleteCount++;
      }
    }
  }
  if (deleteCount > 0) {
    // Ensure we add a new line is added after printing `.` for deleted files
    print(ansi.styleBold.wrap('\nDeleted files: $deleteCount'));
  }
}

String _defineValue(String builder, String option, Object? value) =>
    '$builder=$option=${jsonEncode(value)}';

const _commandPrefix = 'Command:     ';

final _argsExtraLinePrefix = ' ' * (_commandPrefix.length + 2);

const _badGlobItems = {
  '**.dart',
  '**.dart.js.deps',
  '**.dart2js.js.deps',
  '**.dart.js.tar.gz',
  '**.md',
  '**.module',
  '**.ng_placeholder', // Generated by pkg:angular
  '**.yaml',
  '.build.manifest',
  '.dart_tool/**',
  '.packages',
  'packages/\$sdk/**',
  'packages/analyzer/**',
  'packages/build_runner/**',
  'packages/build_web_compilers/**',
  'packages/node_preamble/**',
  'packages/package_resolver/**',
  'packages/test/**',
};

final _badFileGlob = Glob('{${_badGlobItems.join(',')}}');
