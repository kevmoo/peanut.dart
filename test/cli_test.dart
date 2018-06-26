import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

final _output = r'''-d, --directory       (defaults to "web")
-b, --branch          (defaults to "gh-pages")
-c, --build-config    The configuration to use when running `build_runner`.
    --[no-]release    (defaults to on)
-m, --message         (defaults to "Built <directory>")
-h, --help            Prints usage information.''';

void main() {
  test('help', () async {
    var proc = await TestProcess.start('dart', ['bin/peanut.dart', '--help']);

    var output = await proc.stdoutStream().join('\n');
    expect(output, _output);

    await proc.shouldExit(0);
  });

  test('bad flag', () async {
    var proc = await TestProcess.start('dart', ['bin/peanut.dart', '--bob']);

    var output = await proc.stdoutStream().join('\n');
    expect(output, '''Could not find an option named "bob".

$_output''');

    await proc.shouldExit(64);
  });

  test('extra args', () async {
    var proc = await TestProcess.start(
        'dart', ['bin/peanut.dart', 'foo', 'bar', 'baz']);

    var output = await proc.stdoutStream().join('\n');
    expect(output, '''I don't understand the extra arguments: foo, bar, baz

$_output''');

    await proc.shouldExit(64);
  });
}
