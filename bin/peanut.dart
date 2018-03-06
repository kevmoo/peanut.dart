import 'dart:io';

import 'package:args/args.dart';
import 'package:io/io.dart';
import 'package:peanut/peanut.dart';

const _directoryFlag = 'directory';
const _messageFlag = 'message';

main(List<String> args) async {
  ArgParser parser = new ArgParser(allowTrailingOptions: false)
    ..addOption(_directoryFlag, abbr: 'd', defaultsTo: 'web')
    ..addOption('branch', abbr: 'b', defaultsTo: 'gh-pages')
    ..addOption('mode', defaultsTo: 'release', allowed: ['release', 'debug'])
    ..addOption(_messageFlag, abbr: 'm', defaultsTo: 'Built <$_directoryFlag>')
    ..addFlag('help', abbr: 'h', negatable: false);

  ArgResults result;
  try {
    result = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    print('');
    print(parser.usage);
    exitCode = ExitCode.usage.code;
    return;
  }

  if (result['help'] == true) {
    print(parser.usage);
    return;
  }

  if (result.rest.isNotEmpty) {
    print(parser.usage);
    exitCode = 1;
    return;
  }

  var dir = result[_directoryFlag] as String;
  var branch = result['branch'] as String;

  var mode = result['mode'] as String;

  var message = result[_messageFlag] as String;
  if (message == parser.getDefault(_messageFlag)) {
    message = 'Built $dir';
  }

  try {
    await run(dir, branch, message, mode);
  } catch (e, stack) {
    print(e);
    if (e is! String) {
      print(stack);
    }
    exitCode = 1;
  } finally {
    await ProcessManager.terminateStdIn();
  }
}
