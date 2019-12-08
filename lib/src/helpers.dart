import 'package:path/path.dart' as p;

import 'peanut_exception.dart';

/// Creates a Map where the keys are the relative package directory and the
/// values are the subdirectories to build. For example, in a typical project
/// this will be {'.': {'web'}} indicating that the root directory of the
/// package will target the web/ directory for it's entrypoint.
///
/// See https://github.com/dart-lang/build/blob/master/build_config/README.md
/// for more information on build targets
Map<String, Set<String>> targetDirectories(
  String workingDir,
  Iterable<String> directories,
) {
  // key: package dir; value: all dirs to build within that package
  final targetDirs = <String, Set<String>>{};

  for (var dir in directories) {
    final fullPath = p.normalize(p.join(workingDir, dir));

    if (p.equals(workingDir, dir)) {
      throw PeanutException(
          '"$dir" is the same as the working directory, which is not allowed.');
    }

    if (!p.isWithin(workingDir, fullPath)) {
      throw PeanutException(
          '"$dir" is not in the working directory "$workingDir".');
    }

    final pkgDir = p.relative(p.dirname(fullPath), from: workingDir);

    if (!targetDirs
        .putIfAbsent(pkgDir, () => <String>{})
        .add(p.split(fullPath).last)) {
      // Duplicate! Do...something?
    }
  }

  return targetDirs;
}

/// Creates a Map where the keys are the relative paths in the output directory
/// and the values are relative paths to the target directories they were built
/// from. For example, a project with two targets, 'example', and 'web' results
/// in {'example': 'example', 'web': 'web'}
Map<String, String> outputDirectoryMap(Map<String, Set<String>> input) {
  // Only one package, so use the build directory paths
  if (input.length == 1) {
    final entry = input.entries.single;

    final output = Map<String, String>.fromEntries(entry.value
        .map((path) => MapEntry(pkgNormalize(entry.key, path), path)));

    // Only one build directory, so put it at the root!
    if (output.length == 1) {
      return {output.keys.single: '.'};
    }

    return output;
  }

  final sharedRootSegments = <String>[];
  final firstKeyPathSegments = p.split(input.keys.first);
  for (var i = 0; i < firstKeyPathSegments.length; i++) {
    final testSharedRoot = p.joinAll([
      ...sharedRootSegments,
      firstKeyPathSegments[i],
    ]);

    if (input.keys.every((pkgPath) => p.isWithin(testSharedRoot, pkgPath))) {
      sharedRootSegments.add(firstKeyPathSegments[i]);
    } else {
      break;
    }
  }

  final sharedRoot = p.joinAll(sharedRootSegments);

  String minimalOutputPath(String path) {
    if (sharedRoot.isEmpty) {
      return path;
    }
    assert(p.isWithin(sharedRoot, path),
        'Expected `$path` to be within `$sharedRoot`.');
    return p.relative(path, from: sharedRoot);
  }

  if (input.entries.every((entry) {
    // Must be one build dir per package
    if (entry.value.length > 1) {
      return false;
    }

    // Directories cannot contain each other
    if (input.keys.any((k) => p.isWithin(entry.key, k))) {
      return false;
    }

    // Then we can just use the package directory names!
    return true;
  })) {
    return Map.fromEntries(
      input.entries.map(
        (entry) => MapEntry(pkgNormalize(entry.key, entry.value.single),
            minimalOutputPath(entry.key)),
      ),
    );
  }

  return Map.fromEntries(
      input.entries.expand((entry) => entry.value.map((path) {
            final pkgPath = pkgNormalize(entry.key, path);
            return MapEntry(pkgPath, minimalOutputPath(pkgPath));
          })));
}

String pkgNormalize(String pkgDir, String buildDir) =>
    p.normalize(p.join(pkgDir, buildDir));
