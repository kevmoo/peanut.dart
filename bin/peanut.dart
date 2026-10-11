#!/usr/bin/env dart

import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:peanut/src/peanut.dart';
import 'package:peanut/src/peanut_exception.dart';
import 'package:peanut/src/version.dart';

const _formatExceptionHeader = 'FormatException: ';

Future<void> main(List<String> args) async {
  final options = _getOptions(args);
  if (options == null) {
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
      "I don't understand the extra arguments: ${options.rest.join(', ')}",
    );
    print('');
    _printUsage();
    exitCode = ExitCode.usage.code;
    return;
  }

  try {
    await run(options: options);
  } on PackageException catch (e) {
    for (var detail in e.details) {
      printError(detail.error);
      if (detail.description != null) {
        printError(detail.description);
      }
    }
    exitCode = ExitCode.config.code;
  } on PeanutException catch (e, stack) {
    printError(e);
    exitCode = e.exitCode;
    if (options.verbose) {
      printError(stack);
    }
  } catch (e, stack) {
    printError(e);
    print(stack);
    exitCode = 1;
  }
}

void _printUsage() {
  print('''
Usage: peanut [<args>]

${styleBold.wrap('Arguments:')}
$parserUsage''');
}

const _peanutConfigFile = 'peanut.yaml';

final _optionsFile = File(_peanutConfigFile);

Options? _getOptions(List<String> args) {
  try {
    Options? fromConfig;
    if (_optionsFile.existsSync()) {
      fromConfig = checkedYamlDecode(
        _optionsFile.readAsStringSync(),
        decodeYaml,
        sourceUrl: Uri.parse(_peanutConfigFile),
      );
    }

    return parseOptions(args).merge(fromConfig);
  } on ParsedYamlException catch (e) {
    printError('Error decoding "$_peanutConfigFile"');
    printError(e.formattedMessage);
    return null;
  } on FormatException catch (e) {
    var message = e.toString();
    if (message.startsWith(_formatExceptionHeader)) {
      message = message.substring(_formatExceptionHeader.length);
    }
    printError(message.trim());
    print('');
    _printUsage();
    return null;
  }
}
