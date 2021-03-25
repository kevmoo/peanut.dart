// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, prefer_expression_function_bodies

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

T _$enumValueHelper<T>(Map<T, String> enumValues, String source) => enumValues
    .entries
    .singleWhere((e) => e.value == source,
        orElse: () =>
            throw ArgumentError('`$source` is not one of the supported values: '
                '${enumValues.values.join(', ')}'))
    .key;

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
    webRenderer: _$enumValueHelper(
        _$WebRendererEnumMapBuildCli, result['web-renderer'] as String),
    webRendererWasParsed: result.wasParsed('web-renderer'),
    help: result['help'] as bool,
    version: result['version'] as bool,
    rest: result.rest);

const _$WebRendererEnumMapBuildCli = <WebRenderer, String>{
  WebRenderer.canvaskit: 'canvaskit',
  WebRenderer.html: 'html'
};

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('directories',
      abbr: 'd',
      help: 'The directories that should be built.\n(defaults to "web")')
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
  ..addOption('web-renderer',
      help:
          'The renderer implementation to use when building for the web. Flutter web only.',
      defaultsTo: 'html',
      allowed: [
        'canvaskit',
        'html'
      ],
      allowedHelp: <String, String>{
        'canvaskit':
            'This renderer uses WebGL and WebAssembly to render graphics.',
        'html':
            'This renderer uses a combination of HTML, CSS, SVG, 2D Canvas, and WebGL.'
      })
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
      'web-renderer'
    ]);
    final val = Options(
      directories: $checkedConvert(json, 'directories',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()) ??
          ['web'],
      branch:
          $checkedConvert(json, 'branch', (v) => v as String?) ?? 'gh-pages',
      buildConfig: $checkedConvert(json, 'build-config', (v) => v as String?),
      release: $checkedConvert(json, 'release', (v) => v as bool?) ?? true,
      message: $checkedConvert(json, 'message', (v) => v as String?) ??
          'Built <directories>',
      sourceBranchInfo:
          $checkedConvert(json, 'source-branch-info', (v) => v as bool?) ??
              true,
      postBuildDartScript:
          $checkedConvert(json, 'post-build-dart-script', (v) => v as String?),
      builderOptions: $checkedConvert(
          json, 'builder-options', (v) => _builderOptionsFromMap(v as Map?)),
      verbose: $checkedConvert(json, 'verbose', (v) => v as bool?) ?? false,
      webRenderer: $checkedConvert(json, 'web-renderer',
              (v) => _$enumDecodeNullable(_$WebRendererEnumMap, v)) ??
          WebRenderer.html,
    );
    return val;
  }, fieldKeyMap: const {
    'buildConfig': 'build-config',
    'sourceBranchInfo': 'source-branch-info',
    'postBuildDartScript': 'post-build-dart-script',
    'builderOptions': 'builder-options',
    'webRenderer': 'web-renderer'
  });
}

Map<String, dynamic> _$OptionsToJson(Options instance) {
  final val = <String, dynamic>{
    'directories': instance.directories,
    'branch': instance.branch,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('build-config', instance.buildConfig);
  val['release'] = instance.release;
  val['message'] = instance.message;
  val['source-branch-info'] = instance.sourceBranchInfo;
  writeNotNull('post-build-dart-script', instance.postBuildDartScript);
  writeNotNull('builder-options', instance.builderOptions);
  val['verbose'] = instance.verbose;
  val['web-renderer'] = _$WebRendererEnumMap[instance.webRenderer];
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$WebRendererEnumMap = {
  WebRenderer.canvaskit: 'canvaskit',
  WebRenderer.html: 'html',
};
