import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

final _configPrefix =
    'Command arguments were provided. Ignoring "peanut.yaml".';

final _output = r'''
Usage: peanut [<args>]

Arguments:
  -d, --directories                (defaults to "web")
  -b, --branch                     (defaults to "gh-pages")
  -c, --build-config               The configuration to use when running
                                   `build_runner`.

      --[no-]release               (defaults to on)
  -m, --message                    (defaults to "Built <directories>")
      --[no-]source-branch-info    Includes the name of the source branch and SHA
                                   in the commit message
                                   (defaults to on)

      --post-build-dart-script     Optional Dart script to run after all builds
                                   have completed, but before files are committed
                                   to the repository.

  -h, --help                       Prints usage information.''';

void main() {
  test('help', () async {
    final proc = await TestProcess.start('dart', ['bin/peanut.dart', '--help']);

    final output = await proc.stdoutStream().join('\n');
    expect(output, '''
$_configPrefix
$_output''');

    await proc.shouldExit(0);
  });

  test('readme', () {
    final content = File('README.md').readAsStringSync();

    expect(content, contains(_output));
  });

  test('bad flag', () async {
    final proc = await TestProcess.start('dart', ['bin/peanut.dart', '--bob']);

    final output = await proc.stdoutStream().join('\n');
    expect(output, '''
$_configPrefix
Could not find an option named "bob".

$_output''');

    await proc.shouldExit(64);
  });

  test('extra args', () async {
    final proc = await TestProcess.start(
        'dart', ['bin/peanut.dart', 'foo', 'bar', 'baz']);

    final output = await proc.stdoutStream().join('\n');
    expect(output, '''
$_configPrefix
I don't understand the extra arguments: foo, bar, baz

$_output''');

    await proc.shouldExit(64);
  });
}
