import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

const _directoryFlag = 'directory';

const defaultMessage = 'Built <$_directoryFlag>';

ArgParser get parser => _$parserForOptions;

@CliOptions()
class Options {
  @CliOption(name: _directoryFlag, abbr: 'd', defaultsTo: 'web')
  final String directory;

  @CliOption(abbr: 'b', defaultsTo: 'gh-pages')
  final String branch;

  @CliOption(
      abbr: 'c', help: 'The configuration to use when running `build_runner`.')
  final String buildConfig;

  final bool buildConfigWasParsed;

  @CliOption(negatable: true, defaultsTo: true)
  final bool release;

  @CliOption(abbr: 'm', defaultsTo: defaultMessage)
  String message;

  @CliOption(abbr: 'h', negatable: false, help: 'Prints usage information.')
  final bool help;

  final List<String> rest;

  Options({
    this.directory = 'web',
    this.branch = 'gh-pages',
    this.buildConfig,
    this.buildConfigWasParsed,
    this.release = true,
    this.message = defaultMessage,
    this.help,
    this.rest,
  });
}
