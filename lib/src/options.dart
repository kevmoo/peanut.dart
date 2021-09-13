import 'dart:io';

import 'package:build_cli_annotations/build_cli_annotations.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaml/yaml.dart';

part 'options.g.dart';

const _directoryFlag = 'directories';
const _defaultBranch = 'gh-pages';
const _defaultDirectory = 'web';
const _defaultRelease = true;
const _defaultVerbose = false;
const _defaultSourceBranchInfo = true;
const _defaultDryRun = false;
const _defaultWebRenderer = WebRenderer.html;

const defaultMessage = 'Built <$_directoryFlag>';

String get parserUsage =>
    _$populateOptionsParser(ArgParser(usageLineLength: 80)).usage;

Options decodeYaml(Map? yaml) => _$OptionsFromJson(yaml!);

enum WebRenderer {
  canvaskit,
  html,
}

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
    help: r'''
The directories that should be built.
(defaults to "web")''',
    convert: _directoriesConvert,
  )
  final List<String> directories;

  @JsonKey(ignore: true)
  final bool directoriesWasParsed;

  @CliOption(
    abbr: 'b',
    help: 'The git branch where the built content should be committed.',
    defaultsTo: _defaultBranch,
  )
  final String branch;

  @JsonKey(ignore: true)
  final bool branchWasParsed;

  @CliOption(
    abbr: 'c',
    help: 'The configuration to use when running `build_runner`.',
  )
  final String? buildConfig;

  @JsonKey(ignore: true)
  final bool buildConfigWasParsed;

  @CliOption(
    defaultsTo: _defaultRelease,
    help: '''
Flutter: enabled passes `--release`, otherwise passes `--profile`.
  Other: enabled passes `--release`, otherwise passes `--no-release`.
''',
  )
  final bool release;

  @JsonKey(ignore: true)
  final bool releaseWasParsed;

  @CliOption(abbr: 'm', defaultsTo: defaultMessage)
  final String message;

  @JsonKey(ignore: true)
  final bool messageWasParsed;

  @CliOption(
    defaultsTo: _defaultSourceBranchInfo,
    help:
        'Includes the name of the source branch and SHA in the commit message',
  )
  final bool sourceBranchInfo;

  @JsonKey(ignore: true)
  final bool sourceBranchInfoWasParsed;

  @CliOption(
    help: 'Optional Dart script to run after all builds have completed, but '
        'before files are committed to the repository.',
  )
  final String? postBuildDartScript;

  @JsonKey(ignore: true)
  final bool postBuildDartScriptWasParsed;

  @CliOption(
    help: '''
Builder options YAML or a path to a file containing builder options YAML.
See the README for details.''',
    convert: _openBuildConfig,
  )
  @JsonKey(fromJson: _builderOptionsFromMap)
  final Map<String, Map<String, dynamic>>? builderOptions;

  @JsonKey(ignore: true)
  final bool builderOptionsWasParsed;

  @CliOption(
    help: 'Print more details when running.',
    defaultsTo: _defaultVerbose,
  )
  final bool verbose;

  @JsonKey(ignore: true)
  final bool verboseWasParsed;

  @CliOption(
    negatable: false,
    defaultsTo: _defaultDryRun,
    help: 'Verifies configuration and prints commands that would be executed, '
        'but does not do any work.',
  )
  @JsonKey(ignore: true)
  final bool dryRun;

  @CliOption(
      defaultsTo: _defaultWebRenderer,
      help: 'The renderer implementation to use when building for the web. '
          'Flutter web only.',
      allowedHelp: {
        WebRenderer.canvaskit:
            'This renderer uses WebGL and WebAssembly to render graphics.',
        WebRenderer.html:
            'This renderer uses a combination of HTML, CSS, SVG, 2D Canvas, '
                'and WebGL.',
      })
  final WebRenderer webRenderer;
  @JsonKey(ignore: true)
  final bool webRendererWasParsed;

  String webRendererString() => _$WebRendererEnumMap[webRenderer]!;

  @CliOption(
    help:
        'Extra arguments to provide to the target CLI within a single string.\n'
        'Examples:\n'
        '--extra-args "--dart-define TEST_VAR=123"\n'
        '--extra-args "--dart-define --base-href=/base/"',
  )
  final String? extraArgs;

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
  final bool extraArgsWasParsed;

  @JsonKey(ignore: true)
  final List<String> rest;

  const Options({
    this.directories = const [_defaultDirectory],
    this.directoriesWasParsed = false,
    this.branch = _defaultBranch,
    this.branchWasParsed = false,
    this.buildConfig,
    this.buildConfigWasParsed = false,
    this.release = _defaultRelease,
    this.releaseWasParsed = false,
    this.message = defaultMessage,
    this.messageWasParsed = false,
    this.sourceBranchInfo = _defaultSourceBranchInfo,
    this.sourceBranchInfoWasParsed = false,
    this.postBuildDartScript,
    this.postBuildDartScriptWasParsed = false,
    this.builderOptions,
    this.builderOptionsWasParsed = false,
    this.verbose = _defaultVerbose,
    this.verboseWasParsed = false,
    this.dryRun = _defaultDryRun,
    this.webRenderer = _defaultWebRenderer,
    this.webRendererWasParsed = false,
    this.extraArgsWasParsed = false,
    this.extraArgs,
    this.help = false,
    this.version = false,
    this.rest = const [],
  });

  Map<String, dynamic> toJson() => _$OptionsToJson(this);

  /// Assumes that `this` was generated via [ArgParser], so all of the
  /// `wasParsed` fields are set (non-`null`).
  Options merge(Options? other) {
    if (other == null) {
      return this;
    }

    return Options(
      branch: branchWasParsed ? branch : other.branch,
      buildConfig: buildConfigWasParsed ? buildConfig : other.buildConfig,
      builderOptions:
          builderOptionsWasParsed ? builderOptions : other.builderOptions,
      directories: directoriesWasParsed ? directories : other.directories,
      dryRun: dryRun,
      extraArgs: extraArgsWasParsed ? extraArgs : other.extraArgs,
      webRenderer: webRendererWasParsed ? webRenderer : other.webRenderer,
      help: help,
      message: messageWasParsed ? message : other.message,
      postBuildDartScript: postBuildDartScriptWasParsed
          ? postBuildDartScript
          : other.postBuildDartScript,
      release: releaseWasParsed ? release : other.release,
      rest: rest,
      sourceBranchInfo:
          sourceBranchInfoWasParsed ? sourceBranchInfo : other.sourceBranchInfo,
      version: version,
      verbose: verboseWasParsed ? verbose : other.verbose,
    );
  }

  List<String>? splitExtraArgs() => extraArgs?.split(' ');
}

List<String> _directoriesConvert(String? input) => input == null
    ? [_defaultDirectory]
    : input.split(',').map((v) => v.trim()).toList();

Map<String, Map<String, dynamic>>? _openBuildConfig(String? pathOrYamlMap) {
  if (pathOrYamlMap == null) {
    return null;
  }

  String? yamlPath = pathOrYamlMap;
  String stringContent;

  if (FileSystemEntity.isFileSync(pathOrYamlMap)) {
    stringContent = File(pathOrYamlMap).readAsStringSync();
  } else {
    stringContent = pathOrYamlMap;
    yamlPath = null;
  }

  try {
    return checkedYamlDecode(
      stringContent,
      _builderOptionsConvert,
      sourceUrl: yamlPath == null ? null : Uri.parse(yamlPath),
    );
  } on ParsedYamlException catch (e) {
    if (e.yamlNode != null && e.yamlNode is! YamlMap) {
      throw FormatException(
          '"$pathOrYamlMap" is neither a path to a YAML file nor a YAML map.');
    }
    rethrow;
  }
}

extension OptionsExtension on Options {
  static const _defaults = Options();
  Set<String> get buildRunnerConfigUsed => {
        if (buildConfig != _defaults.buildConfig) 'build-config',
        if (builderOptions != _defaults.builderOptions) 'builder-options',
      };

  Set<String> get flutterConfigUsed => {
        if (webRenderer != _defaults.webRenderer) 'web-renderer',
      };
}

Map<String, Map<String, dynamic>>? _builderOptionsFromMap(Map? source) =>
    _builderOptionsConvert(source as YamlMap?);

Map<String, Map<String, dynamic>>? _builderOptionsConvert(Map? map) =>
    map == null
        ? null
        : Map<String, Map<String, dynamic>>.fromEntries(
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
