// Mostly copied, with minor tweaks from
// https://github.com/dart-lang/webdev
// At Commit 6d994019a829dc5da8d0a254785fdfa9be29fde9
// Original copyright:

// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import 'peanut_exception.dart';
import 'utils.dart';

const _args = ['pub', 'deps'];
Future<void> _runPubDeps(String workingDirectory) async {
  final result = Process.runSync(
    dartPath,
    _args,
    workingDirectory: workingDirectory,
  );

  if (result.exitCode == 65 || result.exitCode == 66) {
    throw PeanutException((result.stderr as String).trim());
  }

  if (result.exitCode != 0) {
    if ((result.stderr as String).contains(
      'The Flutter SDK is not available.',
    )) {
      throw PeanutException(
        '`pub` failed.\n'
        'This appears to be a Flutter project.\n'
        'Try running `flutter pub global run peanut`.',
      );
    }
    throw ProcessException(
      dartPath,
      _args,
      '***OUT***\n${result.stdout}\n***ERR***\n${result.stderr}\n***',
      exitCode,
    );
  }
}

Future<bool> isFlutterPackage(String pkgDir) async {
  final pubspecLock = await _PubspecLock.read(pkgDir);
  return pubspecLock.isFlutter;
}

Future<void> checkPubspecLock(String pkgDir) async {
  final pubspecLock = await _PubspecLock.read(pkgDir);

  final issues = <PackageExceptionDetails>[];
  if (!pubspecLock.isFlutter) {
    issues
      ..addAll(
        pubspecLock.checkPackage(
          'build_runner',
          VersionConstraint.parse('>=1.3.0 <3.0.0'),
        ),
      )
      ..addAll(
        pubspecLock.checkPackage(
          'build_web_compilers',
          VersionConstraint.parse('>=1.2.0 <5.0.0'),
        ),
      );
  }

  if (issues.isNotEmpty) {
    throw PackageException(issues);
  }
}

Future<String?> getPackageVersion(String workingDir) async {
  final pubSpec = await _Pubspec.read(workingDir);
  return pubSpec.version;
}

const String pubspecFile = 'pubspec.yaml';

class _Pubspec {
  final YamlMap? _pubspec;

  _Pubspec(this._pubspec);

  static Future<_Pubspec> read(String workingDir) async {
    final pubSpec =
        loadYaml(await File(p.join(workingDir, pubspecFile)).readAsString())
            as YamlMap;

    return _Pubspec(pubSpec);
  }

  String? get version => _pubspec?['version'] as String?;
}

class _PubspecLock {
  final YamlMap? _packages;

  _PubspecLock(this._packages);

  static Future<_PubspecLock> read(String pkgDir) async {
    await _runPubDeps(pkgDir);

    final pubspecLock =
        loadYaml(await File(p.join(pkgDir, 'pubspec.lock')).readAsString())
            as YamlMap;

    final packages = pubspecLock['packages'] as YamlMap;
    return _PubspecLock(packages);
  }

  bool get isFlutter {
    final flutterDataMap = _packages?['flutter'] as YamlMap?;

    return flutterDataMap != null;
  }

  List<PackageExceptionDetails> checkPackage(
    String pkgName,
    VersionConstraint constraint, {
    String? forArgument,
    bool? requireDirect,
  }) {
    requireDirect ??= true;
    final issues = <PackageExceptionDetails>[];
    final missingDetails = PackageExceptionDetails.missingDep(
      pkgName,
      constraint,
    );

    final pkgDataMap = _packages?[pkgName] as YamlMap?;
    if (pkgDataMap == null) {
      issues.add(missingDetails);
    } else {
      final dependency = pkgDataMap['dependency'] as String;
      if (requireDirect && !dependency.startsWith('direct ')) {
        issues.add(missingDetails);
      }

      final source = pkgDataMap['source'] as String;
      if (source == 'hosted') {
        // NOTE: pkgDataMap['description'] should be:
        //           `{url: https://pub.dartlang.org, name: [pkgName]}`
        //       If a user is playing around here, they are on their own.

        final version = pkgDataMap['version'] as String;
        final pkgVersion = Version.parse(version);
        if (!constraint.allows(pkgVersion)) {
          final error =
              'The `$pkgName` version – $pkgVersion – is not '
              'within the allowed constraint – $constraint.';
          issues.add(PackageExceptionDetails._(error));
        }
      } else {
        // NOTE: Intentionally not checking non-hosted dependencies: git, path
        //       If a user is playing around here, they are on their own.
      }
    }
    return issues;
  }
}

class PackageException implements Exception {
  final List<PackageExceptionDetails> details;

  final String? unsupportedArgument;

  PackageException(this.details, {this.unsupportedArgument});

  @override
  String toString() => <String>[
    'PackageException',
    ...details.map((e) => e.toString()),
    if (unsupportedArgument != null) unsupportedArgument!,
  ].join('\n');
}

class PackageExceptionDetails {
  final String error;
  final String? description;

  const PackageExceptionDetails._(this.error, {this.description});

  static const noPubspecLock = PackageExceptionDetails._(
    '`pubspec.lock` does not exist.',
    description: 'Run `pub get` first.',
  );

  static PackageExceptionDetails missingDep(
    String pkgName,
    VersionConstraint constraint,
  ) => PackageExceptionDetails._(
    'You must have a dependency on `$pkgName` in `pubspec.yaml`.',
    description: '''
# pubspec.yaml
dev_dependencies:
  $pkgName: $constraint''',
  );

  @override
  String toString() => [error, description].join('\n');
}
