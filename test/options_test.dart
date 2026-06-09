import 'package:checks/checks.dart';
import 'package:peanut/src/options.dart';
import 'package:test/scaffolding.dart';
import 'package:yaml/yaml.dart';

void main() {
  final emptyArgsOptions = parseOptions([]);
  final emptyFileOptions = decodeYaml({});

  test('empty args', () {
    _checkDefault(emptyArgsOptions, _defaultOptions);
  });

  test('empty file', () {
    _checkDefault(emptyFileOptions, _defaultOptions);
  });

  test('merged', () {
    _checkDefault(emptyArgsOptions.merge(emptyFileOptions), _defaultOptions);
  });

  test('all options', () {
    const allOptions = Options(
      branch: 'other-branch',
      buildConfig: 'some config',
      builderOptions: {
        'some': {'options': 'value'},
      },
      directories: ['example'],
      dryRun: true,
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
    _checkDefault(allArgsOptions, allOptions, wasParsed: true);

    final allFileOptions = decodeYaml({
      'branch': 'other-branch',
      'build-config': 'some config',
      'builder-options': YamlMap.wrap({
        'some': {'options': 'value'},
      }),
      'directories': ['example'],
      'message': 'other message',
      'post-build-dart-script': 'some script',
      'release': false,
      'verbose': true,
      'source-branch-info': false,
      'wasm': false,
    });
    _checkDefault(allFileOptions, allOptions, jsonSkippedDefault: false);

    // empty args, full file
    _checkDefault(
      emptyArgsOptions.merge(allFileOptions),
      allOptions,
      jsonSkippedDefault: false,
    );

    // all args, empty file
    _checkDefault(allArgsOptions.merge(emptyFileOptions), allOptions);

    // all args, full file
    _checkDefault(allArgsOptions.merge(allFileOptions), allOptions);
  });
}

const _defaultOptions = Options();

void _checkDefault(
  Options options,
  Options expected, {
  bool? jsonSkippedDefault,
  bool wasParsed = false,
}) {
  check(options.branch).equals(expected.branch);
  check(options.branchWasParsed).equals(wasParsed);
  check(options.buildConfig).equals(expected.buildConfig);
  check(options.buildConfigWasParsed).equals(wasParsed);

  final builderOptions = expected.builderOptions;
  if (builderOptions == null) {
    check(options.builderOptions).isNull();
  } else {
    check(options.builderOptions).isNotNull().deepEquals(builderOptions);
  }
  check(options.builderOptionsWasParsed).equals(wasParsed);

  check(options.directories).deepEquals(expected.directories);
  check(options.directoriesWasParsed).equals(wasParsed);

  check(options.dryRun).equals(jsonSkippedDefault ?? expected.dryRun);
  check(options.help).equals(jsonSkippedDefault ?? expected.help);

  check(options.message).equals(expected.message);
  check(options.messageWasParsed).equals(wasParsed);
  check(options.postBuildDartScript).equals(expected.postBuildDartScript);
  check(options.postBuildDartScriptWasParsed).equals(wasParsed);
  check(options.release).equals(expected.release);
  check(options.releaseWasParsed).equals(wasParsed);
  check(options.sourceBranchInfo).equals(expected.sourceBranchInfo);
  check(options.sourceBranchInfoWasParsed).equals(wasParsed);
  check(options.verbose).equals(expected.verbose);
  check(options.verboseWasParsed).equals(wasParsed);
  check(options.versionInfo).equals(expected.versionInfo);
  check(options.versionInfoWasParsed).equals(expected.versionInfoWasParsed);
  check(options.wasm).equals(expected.wasm);

  check(options.version).equals(jsonSkippedDefault ?? expected.version);
}
