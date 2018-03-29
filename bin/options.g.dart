// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// Generator: CliGenerator
// **************************************************************************

final _$parserForOptions = new ArgParser()
  ..addOption('directory', abbr: 'd', defaultsTo: 'web')
  ..addOption('branch', abbr: 'b', defaultsTo: 'gh-pages')
  ..addOption('mode',
      help: 'The mode to run `pub build` in.',
      defaultsTo: 'release',
      allowed: ['release', 'debug'])
  ..addOption('build-config',
      abbr: 'c',
      help:
          'The configuration to use when running `build_runner`. If this option is not set, `release` is used if `build.release.yaml` exists in the current directory.')
  ..addOption('message', abbr: 'm', defaultsTo: 'Built <directory>')
  ..addOption('build-tool',
      abbr: 't',
      help:
          'If `build.release.yaml` exists in the current directory, defaults to "build". Otherwise, "pub".',
      allowed: [
        'pub',
        'build'
      ])
  ..addFlag('help',
      abbr: 'h', help: 'Prints usage information.', negatable: false);

Options _$parseOptionsResult(ArgResults result) {
  T enumValueHelper<T>(String enumName, List<T> values, String enumValue) =>
      enumValue == null
          ? null
          : values.singleWhere((e) => e.toString() == '$enumName.$enumValue',
              orElse: () => throw new StateError(
                  'Could not find the value `$enumValue` in enum `$enumName`.'));

  return new Options(
      directory: result['directory'] as String,
      branch: result['branch'] as String,
      mode: enumValueHelper(
          'PubBuildMode', PubBuildMode.values, result['mode'] as String),
      modeWasParsed: result.wasParsed('mode'),
      buildConfig: result['build-config'] as String,
      buildConfigWasParsed: result.wasParsed('build-config'),
      message: result['message'] as String,
      buildTool: enumValueHelper(
          'BuildTool', BuildTool.values, result['build-tool'] as String),
      help: result['help'] as bool,
      rest: result.rest);
}

Options parseOptions(List<String> args) {
  var result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
