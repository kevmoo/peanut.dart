Do you ever want to `pub build` into another branch? This is your ticket.

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

-d, --directory       (defaults to "web")
-b, --branch          (defaults to "gh-pages")
    --mode            The mode to run `pub build` in.
                      [release (default), debug]

-c, --build-config    The configuration to use when running `build_runner`. If this option is not set, `release` is used if `build.release.yaml` exists in the current directory.
-m, --message         (defaults to "Built <directory>")
-t, --build-tool      If `build.release.yaml` exists in the current directory, defaults to "build". Otherwise, "pub".
                      [pub (default), build]

-h, --help
```
