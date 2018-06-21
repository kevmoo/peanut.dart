// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) {
  return new Options(
      directory: result['directory'] as String,
      branch: result['branch'] as String,
      buildConfig: result['build-config'] as String,
      buildConfigWasParsed: result.wasParsed('build-config'),
      release: result['release'] as bool,
      message: result['message'] as String,
      help: result['help'] as bool,
      rest: result.rest);
}

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('directory', abbr: 'd', defaultsTo: 'web')
  ..addOption('branch', abbr: 'b', defaultsTo: 'gh-pages')
  ..addOption('build-config',
      abbr: 'c', help: 'The configuration to use when running `build_runner`.')
  ..addFlag('release', defaultsTo: true, negatable: true)
  ..addOption('message', abbr: 'm', defaultsTo: 'Built <directory>')
  ..addFlag('help',
      abbr: 'h', help: 'Prints usage information.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(new ArgParser());

Options parseOptions(List<String> args) {
  var result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
