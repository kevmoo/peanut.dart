import 'package:build_cli_annotations/build_cli_annotations.dart';
import 'package:json_annotation/json_annotation.dart';

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

Options decodeYaml(Map yaml) => _$OptionsFromJson(yaml);

@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  includeIfNull: false,
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

  @JsonKey(ignore: true)
  @CliOption(
    abbr: 'h',
    negatable: false,
    help: 'Prints usage information.',
  )
  final bool help;

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
    this.help = false,
    this.rest = const [],
  })  : branch = branch ?? _defaultBranch,
        directories = directories ?? const [_defaultDirectory],
        message = message ?? defaultMessage,
        release = release ?? _defaultRelease,
        sourceBranchInfo = sourceBranchInfo ?? _defaultSourceBranchInfo;

  Map<String, dynamic> toJson() => _$OptionsToJson(this);
}
