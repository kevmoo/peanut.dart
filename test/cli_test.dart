import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

final _output = r'''-d, --directory       (defaults to "web")
-b, --branch          (defaults to "gh-pages")
    --mode            The mode to run `pub build` in.
                      [release (default), debug]

-c, --build-config    The configuration to use when running `build_runner`. If this option is not set, `release` is used if `build.release.yaml` exists in the current directory.
-m, --message         (defaults to "Built <directory>")
-t, --build-tool      If `build.release.yaml` exists in the current directory, defaults to "build". Otherwise, "pub".
                      [pub (default), build]

-h, --help            ''';

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
    var proc = await TestProcess
        .start('dart', ['bin/peanut.dart', 'foo', 'bar', 'baz']);

    var output = await proc.stdoutStream().join('\n');
    expect(output, '''I don't understand the extra arguments: foo, bar, baz

$_output''');

    await proc.shouldExit(64);
  });
}
