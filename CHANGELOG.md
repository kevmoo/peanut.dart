## 2.0.0

* The public library has been removed. This package is meant to be an executable
  only.

## 1.1.6

* Moved non-executable file out of `/bin` so it's not activated during
  `pub global activate`.

## 1.1.5

* Run `pub` from the SDK invoking `peanut`. Also fixes the case where `pub` is
  not in the user's PATH.

* Send all output to `stdout`.

* Improve exit codes and error messages on failure.

## 1.1.4

* Added `**.dart.js.deps`, `**.dart.js.tar.gz`, `**.ng_placeholder` to the set 
  of files to exclude.

## 1.1.3

* Only warn if the `directory` does not exist. Build could still work.

* Update dependency on `pkg:git`. Allows running `peanut` in a subdirectory of
  a Git repository.

## 1.1.2

* Support the latest `pkg:git`.

## 1.1.1

* Improve sub-process management.

* Print error/warnings in red – where supported.

## 1.1.0

* Initial support for `build_runner` via `--build_tool` option.

* Updated Dart SDK lower-bound to `2.0.0-dev.22`.
  Using `Iterable.whereType<T>` – introduced in this release. 

## 1.0.0

* Set exit code correctly on errors.

## 0.1.0

* Tweak some things.
* Update readme.

## 0.0.2

* Add mode options, to allow `pub build` to run in debug mode.

## 0.0.1+2

* Run `pub` with `runInShell` to make things work on Windows.

## 0.0.1+1

* Added instructions to `README.md`.

## 0.0.1

* Initial version, created by [Stagehand](http://stagehand.pub/)
