import 'dart:io';

import 'package:io/io.dart';
import 'package:peanut/peanut.dart';
import 'package:peanut/src/options.dart';

const _defaultConfig = 'release';
final _defaultConfigFile = 'build.$_defaultConfig.yaml';

main(List<String> args) async {
  Options options;
  try {
    options = parseOptions(args);
  } on FormatException catch (e) {
    printError(e.message);
    print('');
    print(parser.usage);
    exitCode = ExitCode.usage.code;
    return;
  }

  if (options.help) {
    print(parser.usage);
    return;
  }

  if (options.rest.isNotEmpty) {
    printError(
        "I don't understand the extra arguments: ${options.rest.join(', ')}");
    print('');
    print(parser.usage);
    exitCode = ExitCode.usage.code;
    return;
  }

  var buildTool = options.buildTool ?? _buildToolDefault();
  PubBuildMode mode;
  String buildRunnerConfig;

  if (buildTool == BuildTool.build) {
    if (options.modeWasParsed) {
      printError(
          'The `mode` flag is only supported when `build-tool` is "pub".');
      print('');
      print(parser.usage);
      exitCode = ExitCode.usage.code;
      return;
    }
    buildRunnerConfig = options.buildConfig;
    if (buildRunnerConfig == null &&
        FileSystemEntity.isFileSync(_defaultConfigFile)) {
      buildRunnerConfig = _defaultConfig;
    }
  } else {
    if (options.buildConfigWasParsed) {
      printError(
          'The `build-config` flag is only supported when `build-tool` is "build".');
      print('');
      print(parser.usage);
      exitCode = ExitCode.usage.code;
      return;
    }
    mode = options.mode;
    assert(buildTool == BuildTool.pub);
  }

  var message = options.message;
  if (message == defaultMessage) {
    message = 'Built ${options.directory}';
  }

  try {
    await run(options.directory, options.branch, message, buildTool,
        pubBuildMode: mode, buildRunnerConfig: buildRunnerConfig);
  } catch (e, stack) {
    printError(e);
    if (e is! String) {
      print(stack);
    }
    exitCode = 1;
  }
}

BuildTool _buildToolDefault() => FileSystemEntity.isFileSync(_defaultConfigFile)
    ? BuildTool.build
    : BuildTool.pub;
