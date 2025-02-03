import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:path/path.dart' as p;
import 'package:peanut/src/options.dart';
import 'package:peanut/src/utils.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_process/test_process.dart';

const _output = r'''
Usage: peanut [<args>]

Arguments:
-d, --directories                The directories that should be built.
                                 (defaults to "web")
-b, --branch                     The git branch where the built content should
                                 be committed.
                                 (defaults to "gh-pages")
-c, --build-config               The configuration to use when running
                                 `build_runner`.
    --[no-]release               Flutter: enabled passes `--release`, otherwise
                                 passes `--profile`.
                                 Other: enabled passes `--release`, otherwise
                                 passes `--no-release`.
                                 (defaults to on)
-m, --message                    (defaults to "Built <directories>")
    --[no-]source-branch-info    Includes the name of the source branch and SHA
                                 in the commit message
                                 (defaults to on)
    --[no-]version-info          Includes the pubspec version of the package in
                                 the commit message
    --post-build-dart-script     Optional Dart script to run after all builds
                                 have completed, but before files are committed
                                 to the repository.
    --builder-options            Builder options YAML or a path to a file
                                 containing builder options YAML.
                                 See the README for details.
    --[no-]verbose               Print more details when running.
    --dry-run                    Verifies configuration and prints commands that
                                 would be executed, but does not do any work.
    --[no-]wasm                  Whether to build for WebAssembly (WASM).
    --extra-args                 Extra arguments to provide to the target CLI
                                 within a single string.
                                 Examples:
                                 --extra-args "--dart-define TEST_VAR=123"
                                 --extra-args "--dart-define --base-href=/base/"
-h, --help                       Prints usage information.
    --version                    Print the current version.''';

String get _someFilePath => p.join(d.sandbox, 'some_file.yaml');

void main() {
  test('help', () async {
    final proc = await _runPeanut(['--help']);

    final output = await proc.stdoutStream().join('\n');
    expect(output, _output);

    await proc.shouldExit(0);
  });

  test(
    'readme',
    onPlatform: {'windows': const Skip()},
    () {
      final content = File('README.md').readAsStringSync();

      expect(content, contains(_output));
    },
  );

  test('bad flag', () async {
    final proc = await _runPeanut(['--bob']);

    final output = await proc.stdoutStream().join('\n');
    expect(
      output,
      '''
Could not find an option named "--bob".

$_output''',
    );

    await proc.shouldExit(64);
  });

  test('extra args', () async {
    final proc = await _runPeanut(['foo', 'bar', 'baz']);

    final output = await proc.stdoutStream().join('\n');
    expect(
      output,
      '''
I don't understand the extra arguments: foo, bar, baz

$_output''',
    );

    await proc.shouldExit(64);
  });

  group('builder options', () {
    test('not provided', () async {
      expect(parseOptions([]).builderOptions, isNull);
    });

    void expectParseOptionsThrows(List<String> args, Object matcher) {
      expect(
        () => parseOptions(
          args,
        ),
        throwsA(
          isFormatException.having((e) => e.toString(), 'toString()', matcher),
        ),
      );
    }

    group('config file', () {
      test('no file', () {
        expectParseOptionsThrows(
          [
            '--builder-options',
            _someFilePath,
          ],
          '''
FormatException: "$_someFilePath" is neither a path to a YAML file nor a YAML map.''',
        );
      });

      test('valid file', () async {
        await d.file('some_file.yaml', '{"bob": {"jones":42}}').create();

        final options = parseOptions([
          '--builder-options',
          _someFilePath,
        ]);

        expect(options.builderOptions, hasLength(1));
        expect(options.builderOptions, containsPair('bob', {'jones': 42}));
      });

      test('invalid file', () async {
        await d.file('some_file.yaml', 'not good yaml').create();

        expectParseOptionsThrows(
          [
            '--builder-options',
            _someFilePath,
          ],
          '''
FormatException: "$_someFilePath" is neither a path to a YAML file nor a YAML map.''',
        );
      });

      test('invalid yaml shape', () async {
        await d.file('some_file.yaml', '{"bob": "jones"}').create();

        expectParseOptionsThrows(
          [
            '--builder-options',
            _someFilePath,
          ],
          'FormatException: The value for "bob" was not a Map.',
        );
      });

      test(
        'invalid yaml format',
        onPlatform: {'windows': const Skip('path weirdness')},
        () async {
          await d.file('some_file.yaml', '{').create();

          expect(
            () => parseOptions(
              [
                '--builder-options',
                _someFilePath,
              ],
            ),
            throwsA(
              isA<ParsedYamlException>().having(
                (e) {
                  printOnFailure(e.formattedMessage ?? '');
                  return e.formattedMessage;
                },
                'formattedMessage',
                '''
line 1, column 2 of $_someFilePath: Expected node content.
  ╷
1 │ {
  │  ^
  ╵''',
              ),
            ),
          );
        },
      );
    });
  });
}

Future<TestProcess> _runPeanut(List<String> args) =>
    TestProcess.start(dartPath, [
      'bin/peanut.dart',
      ...args,
    ]);
