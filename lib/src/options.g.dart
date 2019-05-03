// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
    directories: _directoriesConvert(result['directories'] as String),
    branch: result['branch'] as String,
    buildConfig: result['build-config'] as String,
    buildConfigWasParsed: result.wasParsed('build-config'),
    release: result['release'] as bool,
    message: result['message'] as String,
    sourceBranchInfo: result['source-branch-info'] as bool,
    postBuildDartScript: result['post-build-dart-script'] as String,
    builderOptions: _openBuildConfig(result['builder-options'] as String),
    help: result['help'] as bool,
    version: result['version'] as bool,
    rest: result.rest);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('directories', abbr: 'd', defaultsTo: 'web')
  ..addOption('branch', abbr: 'b', defaultsTo: 'gh-pages')
  ..addOption('build-config',
      abbr: 'c', help: 'The configuration to use when running `build_runner`.')
  ..addFlag('release', defaultsTo: true, negatable: true)
  ..addOption('message', abbr: 'm', defaultsTo: 'Built <directories>')
  ..addFlag('source-branch-info',
      help:
          'Includes the name of the source branch and SHA in the commit message',
      defaultsTo: true,
      negatable: true)
  ..addOption('post-build-dart-script',
      help:
          'Optional Dart script to run after all builds have completed, but before files are committed to the repository.')
  ..addOption('builder-options',
      help:
          'Builder options YAML or a path to a file containing builder options YAML.\nSee the README for details.')
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
      'builder-options'
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
        builderOptions: $checkedConvert(json, 'builder-options',
            (v) => v == null ? null : _builderOptionsFromMap(v as Map)));
    return val;
  }, fieldKeyMap: const {
    'buildConfig': 'build-config',
    'sourceBranchInfo': 'source-branch-info',
    'postBuildDartScript': 'post-build-dart-script',
    'builderOptions': 'builder-options'
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
  return val;
}
