#!/usr/bin/env dart
import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:peanut/src/peanut.dart';
import 'package:peanut/src/peanut_exception.dart';
import 'package:peanut/src/version.dart';

const _formatExceptionHeader = 'FormatException: ';

void main(List<String> args) async {
  Options options;
  try {
    options = _getOptions(args);
  } on ParsedYamlException catch (e) {
    printError('Error decoding "$_peanutConfigFile"');
    printError(e.formattedMessage);
    exitCode = ExitCode.usage.code;
    return;
  } on FormatException catch (e) {
    var message = e.toString();
    if (message.startsWith(_formatExceptionHeader)) {
      message = message.substring(_formatExceptionHeader.length);
    }
    printError(message.trim());
    print('');
    _printUsage();
    exitCode = ExitCode.usage.code;
    return;
  }

  if (options.help) {
    _printUsage();
    return;
  }

  if (options.version) {
    print(packageVersion);
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

  if (_optionsFile.existsSync() && args.isNotEmpty) {
    print(yellow.wrap(
      'Command arguments were provided. Ignoring "$_peanutConfigFile".',
    ));
  }

  try {
    await run(options: options);
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
      if (e is! PeanutException) {
        print(stack);
      }
      exitCode = 1;
    }
  }
}

void _printUsage() {
  print('''
Usage: peanut [<args>]

${styleBold.wrap('Arguments:')}
${parser.usage}''');
}

const _peanutConfigFile = 'peanut.yaml';

final _optionsFile = File(_peanutConfigFile);

Options _getOptions(List<String> args) {
  if (_optionsFile.existsSync()) {
    if (args.isEmpty) {
      return checkedYamlDecode(
        _optionsFile.readAsStringSync(),
        decodeYaml,
        sourceUrl: _peanutConfigFile,
      );
    } else {
      // We print a notice that the file is ignored because args above in main.
    }
  }

  return parseOptions(args);
}
