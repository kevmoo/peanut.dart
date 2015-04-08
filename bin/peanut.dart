library peanut.bin;

import 'dart:io';

import 'package:args/args.dart';
import 'package:peanut/peanut.dart';

const _directoryFlag = 'directory';
const _messageFlag = 'message';

void main(List<String> args) {
  ArgParser parser = new ArgParser(allowTrailingOptions: false)
    ..addOption(_directoryFlag, abbr: 'd', defaultsTo: 'web')
    ..addOption('branch', abbr: 'b', defaultsTo: 'gh-pages')
    ..addOption(_messageFlag, abbr: 'm', defaultsTo: 'Built <$_directoryFlag>')
    ..addFlag('help', abbr: 'h', negatable: false);

  var result = parser.parse(args);

  if (result['help']) {
    print(parser.usage);
    exit(1);
  }

  if (result.rest.isNotEmpty) {
    print(parser.usage);
    exit(1);
  }

  var dir = result[_directoryFlag];
  var branch = result['branch'];

  var message = result[_messageFlag];
  if (message == parser.getDefault(_messageFlag)) {
    message = "Built $dir";
  }

  run(dir, branch, message);
}
