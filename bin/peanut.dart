import 'dart:io';

import 'package:io/io.dart';
import 'package:peanut/src/peanut.dart';

main(List<String> args) async {
  Options options;
  try {
    options = parseOptions(args);
  } on FormatException catch (e) {
    printError(e.message);
    print('');
    print(parser.usage);
    exitCode = ExitCode.usage.code;
    return;
  }

  if (options.help) {
    print(parser.usage);
    return;
  }

  if (options.rest.isNotEmpty) {
    printError(
        "I don't understand the extra arguments: ${options.rest.join(', ')}");
    print('');
    print(parser.usage);
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
