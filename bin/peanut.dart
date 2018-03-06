import 'dart:io';

import 'package:args/args.dart';
import 'package:io/io.dart';
import 'package:peanut/peanut.dart';

const _directoryFlag = 'directory';
const _messageFlag = 'message';

const _defaultConfig = 'release';
final _defaultConfigFile = 'build.$_defaultConfig.yaml';

main(List<String> args) async {
  ArgParser parser = new ArgParser(allowTrailingOptions: false)
    ..addOption(_directoryFlag, abbr: 'd', defaultsTo: 'web')
    ..addOption('branch', abbr: 'b', defaultsTo: 'gh-pages')
    ..addOption('mode',
        defaultsTo: 'release',
        allowed: ['release', 'debug'],
        help: 'The mode to run `pub build` in.')
    ..addOption('build-config',
        abbr: 'c',
        help: 'The configuration to use when running `build_runner`. '
            'If this option is not set, `$_defaultConfig` is used if '
            '`$_defaultConfigFile` exists in the current directory.')
    ..addOption(_messageFlag, abbr: 'm', defaultsTo: 'Built <$_directoryFlag>')
    ..addOption('build-tool',
        abbr: 't',
        defaultsTo: _buildToolDefault(),
        allowed: buildToolOptions,
        help:
            'If `$_defaultConfigFile` exists in the current directory, defaults'
            ' to "build". Otherwise, "pub".')
    ..addFlag('help', abbr: 'h', negatable: false);

  ArgResults result;
  try {
    result = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    print('');
    print(parser.usage);
    exitCode = ExitCode.usage.code;
    return;
  }

  if (result['help'] == true) {
    print(parser.usage);
    return;
  }

  if (result.rest.isNotEmpty) {
    print(parser.usage);
    exitCode = 1;
    return;
  }

  var dir = result[_directoryFlag] as String;
  var branch = result['branch'] as String;

  var buildTool = result['build-tool'] as String;

  String pubBuildMode;
  String buildRunnerConfig;
  if (buildTool == 'build') {
    if (result.wasParsed('mode')) {
      stderr.writeln(
          'The `mode` flag is only supported when `build-tool` is "pub".');
      print('');
      print(parser.usage);
      exitCode = ExitCode.usage.code;
      return;
    }
    buildRunnerConfig = result['build-config'] as String;
    if (buildRunnerConfig == null &&
        FileSystemEntity.isFileSync(_defaultConfigFile)) {
      buildRunnerConfig = _defaultConfig;
    }
  } else {
    if (result.wasParsed('build-config')) {
      stderr.writeln(
          'The `build-config` flag is only supported when `build-tool` is "build".');
      print('');
      print(parser.usage);
      exitCode = ExitCode.usage.code;
      return;
    }
    assert(buildTool == 'pub');
    pubBuildMode = result['mode'] as String;
  }

  var message = result[_messageFlag] as String;
  if (message == parser.getDefault(_messageFlag)) {
    message = 'Built $dir';
  }

  try {
    await run(dir, branch, message, buildTool,
        pubBuildMode: pubBuildMode, buildRunnerConfig: buildRunnerConfig);
  } catch (e, stack) {
    print(e);
    if (e is! String) {
      print(stack);
    }
    exitCode = 1;
  } finally {
    await ProcessManager.terminateStdIn();
  }
}

String _buildToolDefault() =>
    FileSystemEntity.isFileSync(_defaultConfigFile) ? 'build' : 'pub';
