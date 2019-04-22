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
    help: result['help'] as bool,
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
  ..addFlag('help',
      abbr: 'h', help: 'Prints usage information.', negatable: false);

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
      'buildConfig',
      'release',
      'message',
      'sourceBranchInfo'
    ]);
    final val = Options(
        directories: $checkedConvert(json, 'directories',
            (v) => (v as List)?.map((e) => e as String)?.toList()),
        branch: $checkedConvert(json, 'branch', (v) => v as String),
        buildConfig: $checkedConvert(json, 'buildConfig', (v) => v as String),
        release: $checkedConvert(json, 'release', (v) => v as bool),
        message: $checkedConvert(json, 'message', (v) => v as String),
        sourceBranchInfo:
            $checkedConvert(json, 'sourceBranchInfo', (v) => v as bool));
    return val;
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
  writeNotNull('buildConfig', instance.buildConfig);
  writeNotNull('release', instance.release);
  writeNotNull('message', instance.message);
  writeNotNull('sourceBranchInfo', instance.sourceBranchInfo);
  return val;
}
