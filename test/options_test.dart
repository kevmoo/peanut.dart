import 'package:peanut/src/options.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final emptyArgsOptions = parseOptions([]);
  final emptyFileOptions = decodeYaml({});

  test('defaults', () {
    _checkDefault(emptyArgsOptions, _defaultOptions, isFalse);

    _checkDefault(emptyFileOptions, _defaultOptions, isNull);

    _checkDefault(
        emptyArgsOptions.merge(emptyFileOptions), _defaultOptions, isNull);
  });

  test('all options', () {
    final allOptions = const Options(
      branch: 'other-branch',
      buildConfig: 'some config',
      builderOptions: {
        'some': {'options': 'value'}
      },
      directories: ['example'],
      help: true,
      message: 'other message',
      postBuildDartScript: 'some script',
      release: false,
      sourceBranchInfo: false,
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
      '--message',
      'other message',
      '--help',
      '--post-build-dart-script',
      'some script',
      '--no-release',
      '--no-source-branch-info',
      '--version',
    ]);
    _checkDefault(allArgsOptions, allOptions, isTrue);

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

final _defaultOptions = const Options();

void _checkDefault(
  Options options,
  Options expected,
  Matcher parsedValue, {
  bool jsonSkippedDefault,
}) {
  expect(options.branch, expected.branch);
  expect(options.branchWasParsed, parsedValue);
  expect(options.buildConfig, expected.buildConfig);
  expect(options.buildConfigWasParsed, parsedValue);
  expect(options.builderOptions, expected.builderOptions);
  expect(options.builderOptionsWasParsed, parsedValue);
  expect(options.directories, expected.directories);
  expect(options.directoriesWasParsed, parsedValue);

  expect(options.help, jsonSkippedDefault ?? expected.help);

  expect(options.message, expected.message);
  expect(options.messageWasParsed, parsedValue);
  expect(options.postBuildDartScript, expected.postBuildDartScript);
  expect(options.postBuildDartScriptWasParsed, parsedValue);
  expect(options.release, expected.release);
  expect(options.releaseWasParsed, parsedValue);
  expect(options.sourceBranchInfo, expected.sourceBranchInfo);
  expect(options.sourceBranchInfoWasParsed, parsedValue);

  expect(options.version, jsonSkippedDefault ?? expected.version);
}
