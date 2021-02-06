// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, prefer_expression_function_bodies

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
    directories: _directoriesConvert(result['directories'] as String),
    directoriesWasParsed: result.wasParsed('directories'),
    branch: result['branch'] as String,
    branchWasParsed: result.wasParsed('branch'),
    buildConfig: result['build-config'] as String,
    buildConfigWasParsed: result.wasParsed('build-config'),
    release: result['release'] as bool,
    releaseWasParsed: result.wasParsed('release'),
    message: result['message'] as String,
    messageWasParsed: result.wasParsed('message'),
    sourceBranchInfo: result['source-branch-info'] as bool,
    sourceBranchInfoWasParsed: result.wasParsed('source-branch-info'),
    postBuildDartScript: result['post-build-dart-script'] as String,
    postBuildDartScriptWasParsed: result.wasParsed('post-build-dart-script'),
    builderOptions: _openBuildConfig(result['builder-options'] as String),
    builderOptionsWasParsed: result.wasParsed('builder-options'),
    verbose: result['verbose'] as bool,
    verboseWasParsed: result.wasParsed('verbose'),
    dryRun: result['dry-run'] as bool,
    canvasKit: result['canvas-kit'] as bool,
    canvasKitWasParsed: result.wasParsed('canvas-kit'),
    help: result['help'] as bool,
    version: result['version'] as bool,
    rest: result.rest);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('directories',
      abbr: 'd',
      help: 'The directories that should be built.',
      defaultsTo: 'web')
  ..addOption('branch',
      abbr: 'b',
      help: 'The git branch where the built content should be committed.',
      defaultsTo: 'gh-pages')
  ..addOption('build-config',
      abbr: 'c', help: 'The configuration to use when running `build_runner`.')
  ..addFlag('release',
      help:
          'Flutter: enabled passes `--release`, otherwise passes `--profile`.\n  Other: enabled passes `--release`, otherwise passes `--no-release`.\n',
      defaultsTo: true)
  ..addOption('message', abbr: 'm', defaultsTo: 'Built <directories>')
  ..addFlag('source-branch-info',
      help:
          'Includes the name of the source branch and SHA in the commit message',
      defaultsTo: true)
  ..addOption('post-build-dart-script',
      help:
          'Optional Dart script to run after all builds have completed, but before files are committed to the repository.')
  ..addOption('builder-options',
      help:
          'Builder options YAML or a path to a file containing builder options YAML.\nSee the README for details.')
  ..addFlag('verbose', help: 'Print more details when running.')
  ..addFlag('dry-run',
      help:
          'Verifies configuration and prints commands that would be executed, but does not do any work.',
      negatable: false)
  ..addFlag('canvas-kit',
      help: 'Builds Flutter web apps with CanvasKit.', negatable: false)
  ..addFlag('help',
      abbr: 'h', help: 'Prints usage information.', negatable: false)
  ..addFlag('version', help: 'Print the current version.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Options _$OptionsFromJson(Map json) {
  return $checkedNew('Options', json, () {
    $checkKeys(json, allowedKeys: const [
      'directories',
      'branch',
      'build-config',
      'release',
      'message',
      'source-branch-info',
      'post-build-dart-script',
      'builder-options',
      'verbose',
      'canvas-kit'
    ]);
    final val = Options(
      directories: $checkedConvert(json, 'directories',
          (v) => (v as List)?.map((e) => e as String)?.toList()),
      branch: $checkedConvert(json, 'branch', (v) => v as String),
      buildConfig: $checkedConvert(json, 'build-config', (v) => v as String),
      release: $checkedConvert(json, 'release', (v) => v as bool),
      message: $checkedConvert(json, 'message', (v) => v as String),
      sourceBranchInfo:
          $checkedConvert(json, 'source-branch-info', (v) => v as bool),
      postBuildDartScript:
          $checkedConvert(json, 'post-build-dart-script', (v) => v as String),
      builderOptions: $checkedConvert(
          json, 'builder-options', (v) => _builderOptionsFromMap(v as Map)),
      verbose: $checkedConvert(json, 'verbose', (v) => v as bool),
      canvasKit: $checkedConvert(json, 'canvas-kit', (v) => v as bool),
    );
    return val;
  }, fieldKeyMap: const {
    'buildConfig': 'build-config',
    'sourceBranchInfo': 'source-branch-info',
    'postBuildDartScript': 'post-build-dart-script',
    'builderOptions': 'builder-options',
    'canvasKit': 'canvas-kit'
  });
}

Map<String, dynamic> _$OptionsToJson(Options instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('directories', instance.directories);
  writeNotNull('branch', instance.branch);
  writeNotNull('build-config', instance.buildConfig);
  writeNotNull('release', instance.release);
  writeNotNull('message', instance.message);
  writeNotNull('source-branch-info', instance.sourceBranchInfo);
  writeNotNull('post-build-dart-script', instance.postBuildDartScript);
  writeNotNull('builder-options', instance.builderOptions);
  writeNotNull('verbose', instance.verbose);
  writeNotNull('canvas-kit', instance.canvasKit);
  return val;
}
