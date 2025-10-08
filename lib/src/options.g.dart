// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
  directories: _directoriesConvert(result['directories'] as String?),
  directoriesWasParsed: result.wasParsed('directories'),
  branch: result['branch'] as String,
  branchWasParsed: result.wasParsed('branch'),
  buildConfig: result['build-config'] as String?,
  buildConfigWasParsed: result.wasParsed('build-config'),
  release: result['release'] as bool,
  releaseWasParsed: result.wasParsed('release'),
  message: result['message'] as String,
  messageWasParsed: result.wasParsed('message'),
  sourceBranchInfo: result['source-branch-info'] as bool,
  sourceBranchInfoWasParsed: result.wasParsed('source-branch-info'),
  postBuildDartScript: result['post-build-dart-script'] as String?,
  postBuildDartScriptWasParsed: result.wasParsed('post-build-dart-script'),
  builderOptions: _openBuildConfig(result['builder-options'] as String?),
  builderOptionsWasParsed: result.wasParsed('builder-options'),
  verbose: result['verbose'] as bool,
  verboseWasParsed: result.wasParsed('verbose'),
  dryRun: result['dry-run'] as bool,
  wasm: result['wasm'] as bool,
  extraArgsWasParsed: result.wasParsed('extra-args'),
  extraArgs: result['extra-args'] as String?,
  help: result['help'] as bool,
  version: result['version'] as bool,
  versionInfo: result['version-info'] as bool,
  versionInfoWasParsed: result.wasParsed('version-info'),
  rest: result.rest,
);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption(
    'directories',
    abbr: 'd',
    help: 'The directories that should be built.\n(defaults to "web")',
  )
  ..addOption(
    'branch',
    abbr: 'b',
    help: 'The git branch where the built content should be committed.',
    defaultsTo: 'gh-pages',
  )
  ..addOption(
    'build-config',
    abbr: 'c',
    help: 'The configuration to use when running `build_runner`.',
  )
  ..addFlag(
    'release',
    help:
        'Flutter: enabled passes `--release`, otherwise passes `--profile`.\n  Other: enabled passes `--release`, otherwise passes `--no-release`.\n',
    defaultsTo: true,
  )
  ..addOption('message', abbr: 'm', defaultsTo: 'Built <directories>')
  ..addFlag(
    'source-branch-info',
    help:
        'Includes the name of the source branch and SHA in the commit message',
    defaultsTo: true,
  )
  ..addFlag(
    'version-info',
    help: 'Includes the pubspec version of the package in the commit message',
  )
  ..addOption(
    'post-build-dart-script',
    help:
        'Optional Dart script to run after all builds have completed, but before files are committed to the repository.',
  )
  ..addOption(
    'builder-options',
    help:
        'Builder options YAML or a path to a file containing builder options YAML.\nSee the README for details.',
  )
  ..addFlag('verbose', help: 'Print more details when running.')
  ..addFlag(
    'dry-run',
    help:
        'Verifies configuration and prints commands that would be executed, but does not do any work.',
    negatable: false,
  )
  ..addFlag('wasm', help: 'Whether to build for WebAssembly (WASM).')
  ..addOption(
    'extra-args',
    help:
        'Extra arguments to provide to the target CLI within a single string.\nExamples:\n--extra-args "--dart-define TEST_VAR=123"\n--extra-args "--dart-define --base-href=/base/"',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Prints usage information.',
    negatable: false,
  )
  ..addFlag('version', help: 'Print the current version.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Options _$OptionsFromJson(Map json) => $checkedCreate(
  'Options',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'directories',
        'branch',
        'build-config',
        'release',
        'message',
        'source-branch-info',
        'version-info',
        'post-build-dart-script',
        'builder-options',
        'verbose',
        'wasm',
        'extra-args',
      ],
    );
    final val = Options(
      directories: $checkedConvert(
        'directories',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ??
            const [_defaultDirectory],
      ),
      branch: $checkedConvert('branch', (v) => v as String? ?? _defaultBranch),
      buildConfig: $checkedConvert('build-config', (v) => v as String?),
      release: $checkedConvert('release', (v) => v as bool? ?? _defaultRelease),
      message: $checkedConvert(
        'message',
        (v) => v as String? ?? defaultMessage,
      ),
      sourceBranchInfo: $checkedConvert(
        'source-branch-info',
        (v) => v as bool? ?? _defaultSourceBranchInfo,
      ),
      postBuildDartScript: $checkedConvert(
        'post-build-dart-script',
        (v) => v as String?,
      ),
      builderOptions: $checkedConvert(
        'builder-options',
        (v) => _builderOptionsFromMap(v as Map?),
      ),
      verbose: $checkedConvert('verbose', (v) => v as bool? ?? _defaultVerbose),
      wasm: $checkedConvert('wasm', (v) => v as bool? ?? false),
      extraArgs: $checkedConvert('extra-args', (v) => v as String?),
      versionInfo: $checkedConvert(
        'version-info',
        (v) => v as bool? ?? _defaultVersionInfo,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'buildConfig': 'build-config',
    'sourceBranchInfo': 'source-branch-info',
    'postBuildDartScript': 'post-build-dart-script',
    'builderOptions': 'builder-options',
    'extraArgs': 'extra-args',
    'versionInfo': 'version-info',
  },
);

Map<String, dynamic> _$OptionsToJson(Options instance) => <String, dynamic>{
  'directories': instance.directories,
  'branch': instance.branch,
  if (instance.buildConfig case final value?) 'build-config': value,
  'release': instance.release,
  'message': instance.message,
  'source-branch-info': instance.sourceBranchInfo,
  'version-info': instance.versionInfo,
  if (instance.postBuildDartScript case final value?)
    'post-build-dart-script': value,
  if (instance.builderOptions case final value?) 'builder-options': value,
  'verbose': instance.verbose,
  'wasm': instance.wasm,
  if (instance.extraArgs case final value?) 'extra-args': value,
};
