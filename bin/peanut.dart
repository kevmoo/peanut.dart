#!/usr/bin/env dart
import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';
import 'package:io/ansi.dart';
import 'package:peanut/src/peanut.dart';

main(List<String> args) async {
  Options options;
  try {
    options = parseOptions(args);
  } on FormatException catch (e) {
    printError(e.message);
    print('');
    _printUsage();
    exitCode = ExitCode.usage.code;
    return;
  }

  if (options.help) {
    _printUsage();
    return;
  }

  if (options.rest.isNotEmpty) {
    printError(
        "I don't understand the extra arguments: ${options.rest.join(', ')}");
    print('');
    _printUsage();
    exitCode = ExitCode.usage.code;
    return;
  }

  if (options.message == defaultMessage) {
    options.message = 'Built ${options.directory}';
  }

  try {
    await run(options);
  } catch (e, stack) {
    if (e is PackageException) {
      for (var detail in e.details) {
        printError(detail.error);
        if (detail.description != null) {
          printError(detail.description);
        }
      }
      exitCode = ExitCode.config.code;
    } else {
      printError(e);
      if (e is! String) {
        print(stack);
      }
      exitCode = 1;
    }
  }
}


String _indent(String input) =>
    LineSplitter.split(input).map((l) => '  $l'.trimRight()).join('\n');

void _printUsage() {
  print('''
Usage: peanut [<args>]

${styleBold.wrap('Arguments:')}
${_indent(parser.usage)}''');
}
