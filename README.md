[![Pub Package](https://img.shields.io/pub/v/peanut.svg)](https://pub.dartlang.org/packages/peanut)
[![Build Status](https://travis-ci.org/kevmoo/peanut.dart.svg?branch=master)](https://travis-ci.org/kevmoo/peanut.dart)

Do you ever want to `pub run build_runner build` into another branch? This is your ticket.

### Install

```
$ pub global activate peanut
```

### Run

```
$ cd ~/my_dart_proj/
$ peanut
```

This will build your project into a temporary directory, and then it will update the local `gh-pages` branch with its contents.

### Git tricks

The easiest way to push your `gh-pages` branch to github (without switching from your working branch) is:

```
$ git push origin --set-upstream gh-pages
```

To create (or update) your local `gh-pages` branch to match what's on the server.

```
$ git update-ref refs/heads/gh-pages origin/gh-pages
```

This is also useful if you want to undo a `peanut` run.

### Options

```console
$ peanut --help
Usage: peanut [<args>]

Arguments:
  -d, --directories                (defaults to "web")
  -b, --branch                     (defaults to "gh-pages")
  -c, --build-config               The configuration to use when running
                                   `build_runner`.

      --[no-]release               (defaults to on)
  -m, --message                    (defaults to "Built <directories>")
      --[no-]source-branch-info    Includes the name of the source branch and SHA
                                   in the commit message
                                   (defaults to on)

      --post-build-dart-script     Optional Dart script to run after all builds
                                   have completed, but before files are committed
                                   to the repository.

  -h, --help                       Prints usage information.
```
