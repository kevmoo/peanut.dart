import 'package:peanut/src/options.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final emptyArgsOptions = parseOptions([]);
  final emptyFileOptions = decodeYaml({});

  test('empty args', () {
    _checkDefault(emptyArgsOptions, _defaultOptions, isFalse);
  });

  test('empty file', () {
    _checkDefault(emptyFileOptions, _defaultOptions, isNull);
  });

  test('merged', () {
    _checkDefault(
      emptyArgsOptions.merge(emptyFileOptions),
      _defaultOptions,
      isNull,
    );
  });

  test('all options', () {
    const allOptions = Options(
      branch: 'other-branch',
      buildConfig: 'some config',
      builderOptions: {
        'some': {'options': 'value'}
      },
      directories: ['example'],
      dryRun: true,
      webRenderer: WebRenderer.canvaskit,
      help: true,
      message: 'other message',
      postBuildDartScript: 'some script',
      release: false,
      sourceBranchInfo: false,
      verbose: true,
      version: true,
    );

    final allArgsOptions = parseOptions([
      '--branch',
      'other-branch',
      '--build-config',
      'some config',
      '--builder-options',
      'some: {options: value}',
      '--directories',
      'example',
      '--dry-run',
      '--web-renderer',
      'canvaskit',
      '--message',
      'other message',
      '--help',
      '--post-build-dart-script',
      'some script',
      '--no-release',
      '--no-source-branch-info',
      '--verbose',
      '--version',
    ]);
    _checkDefault(allArgsOptions, allOptions, isTrue, wasParsed: true);

    final allFileOptions = decodeYaml({
      'branch': 'other-branch',
      'build-config': 'some config',
      'builder-options': YamlMap.wrap({
        'some': {'options': 'value'}
      }),
      'directories': ['example'],
      'message': 'other message',
      'post-build-dart-script': 'some script',
      'release': false,
      'verbose': true,
      'source-branch-info': false,
    });
    _checkDefault(
      allFileOptions,
      allOptions,
      isNull,
      jsonSkippedDefault: false,
    );

    // empty args, full file
    _checkDefault(
      emptyArgsOptions.merge(allFileOptions),
      allOptions,
      isNull,
      jsonSkippedDefault: false,
    );

    // all args, empty file
    _checkDefault(allArgsOptions.merge(emptyFileOptions), allOptions, isNull);

    // all args, full file
    _checkDefault(allArgsOptions.merge(allFileOptions), allOptions, isNull);
  });
}

const _defaultOptions = Options();

void _checkDefault(
  Options options,
  Options expected,
  Matcher parsedValue, {
  bool? jsonSkippedDefault,
  bool wasParsed = false,
}) {
  expect(options.branch, expected.branch);
  expect(options.branchWasParsed, wasParsed);
  expect(options.buildConfig, expected.buildConfig);
  expect(options.buildConfigWasParsed, wasParsed);
  expect(options.builderOptions, expected.builderOptions);
  expect(options.builderOptionsWasParsed, wasParsed);
  expect(options.directories, expected.directories);
  expect(options.directoriesWasParsed, wasParsed);

  expect(options.dryRun, jsonSkippedDefault ?? expected.dryRun);
  expect(options.help, jsonSkippedDefault ?? expected.help);

  expect(options.message, expected.message);
  expect(options.messageWasParsed, wasParsed);
  expect(options.postBuildDartScript, expected.postBuildDartScript);
  expect(options.postBuildDartScriptWasParsed, wasParsed);
  expect(options.release, expected.release);
  expect(options.releaseWasParsed, wasParsed);
  expect(options.sourceBranchInfo, expected.sourceBranchInfo);
  expect(options.sourceBranchInfoWasParsed, wasParsed);
  expect(options.verbose, expected.verbose);
  expect(options.verboseWasParsed, wasParsed);

  expect(options.version, jsonSkippedDefault ?? expected.version);
}
