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
$ git push origin gh-pages:gh-pages
```

To create (or update) your local `gh-pages` branch to match what's on the server.

```
$ git update-ref refs/heads/gh-pages origin/gh-pages
```

This is also useful if you want to undo a `peanut` run.

### Options

```
$ peanut --help
```


```
-d, --directory    (defaults to "web")
-b, --branch       (defaults to "gh-pages")
-m, --message      (defaults to "Built <directory>")
-h, --help
```
