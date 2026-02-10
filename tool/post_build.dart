import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// This script is run by peanut after the build is complete.
///
/// It modifies the `index.html` file in the build output directory to include
/// information about the tool version and the git commit.
Future<void> main(List<String> args) async {
  final buildRoot = args[0];
  final outputMap = jsonDecode(args[1]) as Map<String, dynamic>;

  // This example script assumes it only operates on one directory.
  // A more robust script could iterate over `outputMap.values`.
  final outputDir = outputMap.values.first as String;
  final htmlFilePath = p.join(buildRoot, outputDir, 'index.html');

  final htmlFile = File(htmlFilePath);
  final contents = htmlFile.readAsStringSync();

  // Get Tool version - in this case Dart version
  final version = 'Dart version ${Platform.version}';

  // Get git SHA and dirty state
  final clean = _isWorkingTreeClean();

  // NO POINT in including a SHA if it's invalid
  final gitInfo = clean ? _runGit(['rev-parse', 'HEAD']) : 'DIRTY';

  final newContent = contents
      .replaceAll('{{tool_version}}', version)
      .replaceAll('{{git_info}}', gitInfo);

  htmlFile.writeAsStringSync(newContent);
}

String _runGit(List<String> args) {
  final result = Process.runSync('git', args);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      args,
      result.stderr as String,
      result.exitCode,
    );
  }

  return (result.stdout as String).trim();
}

bool _isWorkingTreeClean() => _runGit(['status', '--porcelain']).isEmpty;
