import 'package:peanut/src/helpers.dart';
import 'package:test/test.dart';

void _test(
  List<String> directories,
  Map<String, Set<String>> expectedTargetDirectories,
  Map<String, String> outputMap,
) {
  final value = targetDirectories('root', directories);
  expect(value, expectedTargetDirectories, reason: 'target directories');
  expect(outputDirectoryMap(value), outputMap, reason: 'output map');
}

void main() {
  test('single at root', () {
    _test(
      ['web'],
      {
        '.': {'web'}
      },
      {'web': '.'},
    );
  });

  test('single in sub directory', () {
    _test(
      ['pkg1/web'],
      {
        'pkg1': {'web'}
      },
      {'pkg1/web': '.'},
    );
  });

  test('two in one root', () {
    _test(
      ['example', 'web'],
      {
        '.': {'example', 'web'}
      },
      {
        'example': 'example',
        'web': 'web',
      },
    );
  });

  test('two in a subdirectory package', () {
    _test(
      ['pkg/example', 'pkg/web'],
      {
        'pkg': {'example', 'web'}
      },
      {
        'pkg/example': 'example',
        'pkg/web': 'web',
      },
    );
  });

  test('2 packages, one build dir each', () {
    _test(
      ['example1/example', 'example2/web'],
      {
        'example1': {'example'},
        'example2': {'web'},
      },
      {
        'example1/example': 'example1',
        'example2/web': 'example2',
      },
    );
  });

  test('2 packages, two build dirs each', () {
    _test(
      ['example1/example', 'example1/web', 'example2/example', 'example2/web'],
      {
        'example1': {'example', 'web'},
        'example2': {'example', 'web'},
      },
      {
        'example1/example': 'example1/example',
        'example1/web': 'example1/web',
        'example2/example': 'example2/example',
        'example2/web': 'example2/web',
      },
    );
  });

  test('2 deep packages, one build dir each', () {
    _test(
      ['dir/example1/example', 'dir/example2/web'],
      {
        'dir/example1': {'example'},
        'dir/example2': {'web'},
      },
      {
        'dir/example1/example': 'example1',
        'dir/example2/web': 'example2',
      },
    );
  });

  test('2 deeper packages, one build dir each', () {
    _test(
      ['dir1/dir2/example1/example', 'dir1/dir2/example2/web'],
      {
        'dir1/dir2/example1': {'example'},
        'dir1/dir2/example2': {'web'},
      },
      {
        'dir1/dir2/example1/example': 'example1',
        'dir1/dir2/example2/web': 'example2',
      },
    );
  });

  test('2 deep packages, two build dirs each', () {
    _test(
      [
        'dir/example1/example',
        'dir/example1/web',
        'dir/example2/example',
        'dir/example2/web'
      ],
      {
        'dir/example1': {'example', 'web'},
        'dir/example2': {'example', 'web'},
      },
      {
        'dir/example1/example': 'example1/example',
        'dir/example1/web': 'example1/web',
        'dir/example2/example': 'example2/example',
        'dir/example2/web': 'example2/web',
      },
    );
  });

  test('3 packages, one root, one build dir each', () {
    _test(
      ['web', 'example1/example', 'example2/web'],
      {
        '.': {'web'},
        'example1': {'example'},
        'example2': {'web'},
      },
      {
        'web': 'web',
        'example1/example': 'example1/example',
        'example2/web': 'example2/web',
      },
    );
  });

  test('one root, one subdir', () {
    _test(
      ['web', 'example1/web'],
      {
        '.': {'web'},
        'example1': {'web'},
      },
      {
        'web': 'web',
        'example1/web': 'example1/web',
      },
    );
  });

  test('many things', () {
    _test(
      ['web', 'example1/example', 'example1/web', 'example2/web'],
      {
        '.': {'web'},
        'example1': {'example', 'web'},
        'example2': {'web'},
      },
      {
        'web': 'web',
        'example1/example': 'example1/example',
        'example1/web': 'example1/web',
        'example2/web': 'example2/web',
      },
    );
  });
}
