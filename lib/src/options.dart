import 'dart:io';

import 'package:build_cli_annotations/build_cli_annotations.dart';
import 'package:io/ansi.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaml/yaml.dart';

part 'options.g.dart';

const _directoryFlag = 'directories';
const _defaultBranch = 'gh-pages';
const _defaultDirectory = 'web';
const _defaultRelease = true;
const _defaultSourceBranchInfo = true;

const defaultMessage = 'Built <$_directoryFlag>';

ArgParser get parser => _$populateOptionsParser(ArgParser(usageLineLength: 80));

List<String> _directoriesConvert(String input) =>
    input.split(',').map((v) => v.trim()).toList();

Map<String, Map<String, dynamic>> _openBuildConfig(String pathOrYamlMap) {
  if (pathOrYamlMap == null) {
    return null;
  }

  final stringContent = FileSystemEntity.isFileSync(pathOrYamlMap)
      ? File(pathOrYamlMap).readAsStringSync()
      : pathOrYamlMap;

  try {
    final node = loadYaml(stringContent, sourceUrl: pathOrYamlMap);

    if (node is YamlMap) {
      return _builderOptionsConvert(node);
    }

    throw FormatException(
        '"$pathOrYamlMap" is neither a path to a YAML file nor valid YAML.');
  } catch (e) {
    print(red.wrap('Problem with --builder-options'));
    rethrow;
  }
}

Map<String, Map<String, dynamic>> _builderOptionsConvert(YamlMap map) =>
    Map<String, Map<String, dynamic>>.fromEntries(
      map.entries.map((e) {
        final value = e.value;
        if (value is YamlMap) {
          return MapEntry(
            e.key as String,
            value.cast<String, dynamic>(),
          );
        }

        throw FormatException('The value for "${e.key}" was not a Map.');
      }),
    );

Map<String, Map<String, dynamic>> _mapCast(Map source) =>
    _builderOptionsConvert(source as YamlMap);

Options decodeYaml(Map yaml) => _$OptionsFromJson(yaml);

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  includeIfNull: false,
  fieldRename: FieldRename.kebab,
)
@CliOptions()
class Options {
  @CliOption(
    name: _directoryFlag,
    abbr: 'd',
    defaultsTo: _defaultDirectory,
    convert: _directoriesConvert,
  )
  final List<String> directories;

  @CliOption(abbr: 'b', defaultsTo: _defaultBranch)
  final String branch;

  @CliOption(
    abbr: 'c',
    help: 'The configuration to use when running `build_runner`.',
  )
  final String buildConfig;

  @JsonKey(ignore: true)
  final bool buildConfigWasParsed;

  @CliOption(negatable: true, defaultsTo: _defaultRelease)
  final bool release;

  @CliOption(abbr: 'm', defaultsTo: defaultMessage)
  final String message;

  @CliOption(
    negatable: true,
    defaultsTo: _defaultSourceBranchInfo,
    help:
        'Includes the name of the source branch and SHA in the commit message',
  )
  final bool sourceBranchInfo;

  @CliOption(
    help: 'Optional Dart script to run after all builds have completed, but '
        'before files are committed to the repository.',
  )
  final String postBuildDartScript;

  @CliOption(
    help: '''
Builder options YAML or a path to a file containing builder options YAML.
See the README for details.''',
    convert: _openBuildConfig,
  )
  @JsonKey(fromJson: _mapCast)
  final Map<String, Map<String, dynamic>> builderOptions;

  @JsonKey(ignore: true)
  @CliOption(
    abbr: 'h',
    negatable: false,
    help: 'Prints usage information.',
  )
  final bool help;

  @JsonKey(ignore: true)
  @CliOption(
    negatable: false,
    help: 'Print the current version.',
  )
  final bool version;

  @JsonKey(ignore: true)
  final List<String> rest;

  const Options({
    List<String> directories,
    String branch,
    this.buildConfig,
    this.buildConfigWasParsed,
    bool release,
    String message,
    bool sourceBranchInfo,
    this.postBuildDartScript,
    this.builderOptions,
    this.help = false,
    this.version = false,
    this.rest = const [],
  })  : branch = branch ?? _defaultBranch,
        directories = directories ?? const [_defaultDirectory],
        message = message ?? defaultMessage,
        release = release ?? _defaultRelease,
        sourceBranchInfo = sourceBranchInfo ?? _defaultSourceBranchInfo;

  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}
