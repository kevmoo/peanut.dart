import 'dart:io';

import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final director = args[0];
  final htmlFilePath = p.join(director, 'index.html');

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
