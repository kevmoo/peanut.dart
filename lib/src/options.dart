import 'package:build_cli_annotations/build_cli_annotations.dart';

import 'enums.dart';

part 'options.g.dart';

const _defaultConfig = 'release';
const _defaultConfigFile = 'build.$_defaultConfig.yaml';
const _directoryFlag = 'directory';

const defaultMessage = 'Built <$_directoryFlag>';

ArgParser get parser => _$parserForOptions;

@CliOptions()
class Options {
  @CliOption(name: _directoryFlag, abbr: 'd', defaultsTo: 'web')
  final String directory;

  @CliOption(abbr: 'b', defaultsTo: 'gh-pages')
  final String branch;

  @CliOption(
      defaultsTo: PubBuildMode.release, help: 'The mode to run `pub build` in.')
  final PubBuildMode mode;

  final bool modeWasParsed;

  @CliOption(
      abbr: 'c',
      help: 'The configuration to use when running `build_runner`. '
          'If this option is not set, `$_defaultConfig` is used if '
          '`$_defaultConfigFile` exists in the current directory.')
  final String buildConfig;

  final bool buildConfigWasParsed;

  @CliOption(abbr: 'm', defaultsTo: defaultMessage)
  final String message;

  @CliOption(
      abbr: 't',
      help: 'If `$_defaultConfigFile` exists in the current directory, defaults'
          ' to "build". Otherwise, "pub".')
  final BuildTool buildTool;

  @CliOption(abbr: 'h', negatable: false, help: 'Prints usage information.')
  final bool help;

  final List<String> rest;

  Options(
      {this.directory,
      this.branch,
      this.mode,
      this.modeWasParsed,
      this.buildConfig,
      this.buildConfigWasParsed,
      this.message,
      this.buildTool,
      this.help,
      this.rest});
}
