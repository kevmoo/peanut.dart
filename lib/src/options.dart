import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

const _directoryFlag = 'directory';
const _defaultBranch = 'gh-pages';
const _defaultDirectory = 'web';
const _defaultRelease = true;
const _defaultIncludeSourceBranchInfo = true;

const defaultMessage = 'Built <$_directoryFlag>';

ArgParser get parser => _$populateOptionsParser(ArgParser(usageLineLength: 80));

@CliOptions()
class Options {
  @CliOption(name: _directoryFlag, abbr: 'd', defaultsTo: _defaultDirectory)
  final String directory;

  @CliOption(abbr: 'b', defaultsTo: _defaultBranch)
  final String branch;

  @CliOption(
    abbr: 'c',
    help: 'The configuration to use when running `build_runner`.',
  )
  final String buildConfig;

  final bool buildConfigWasParsed;

  @CliOption(negatable: true, defaultsTo: _defaultRelease)
  final bool release;

  @CliOption(abbr: 'm', defaultsTo: defaultMessage)
  final String message;

  @CliOption(
    negatable: true,
    defaultsTo: _defaultIncludeSourceBranchInfo,
    help:
        'Includes the name of the source branch and SHA in the commit message',
  )
  final bool sourceBranchInfo;

  @CliOption(
    abbr: 'h',
    negatable: false,
    help: 'Prints usage information.',
  )
  final bool help;

  final List<String> rest;

  const Options({
    this.directory = _defaultDirectory,
    this.branch = _defaultBranch,
    this.buildConfig,
    this.buildConfigWasParsed,
    this.release = _defaultRelease,
    this.message = defaultMessage,
    this.sourceBranchInfo = _defaultIncludeSourceBranchInfo,
    this.help,
    this.rest,
  });
}
