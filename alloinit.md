---
title: alloinit
---
## `alloinit` ([download][alloinit-download]) ##

> One-step [`allotemplate`][allotemplate] initializer!

### Usage ###

Starting an [`allotemplate`][allotemplate] project in `proj`:

```sh
./alloinit proj
```

Update Allolib dependencies ([`allolib`][allolib] and [`al_ext`][al_ext]):

```sh
./alloinit -u
```

Start an [`allotemplate`][allotemplate] project with submodule instead of
symlinked dependencies (i.e., a traditional project):

```sh
./alloinit -N proj
```

### Installation ###

Get `alloinit` [here][alloinit-download] or use:

```sh
curl https://allolib-s22.github.io/notes-ethwu/alloinit > alloinit
chmod +x ./alloinit
./alloinit -h
```

#### Advanced Usage ####

Specify the Allolib dependency directory (default is `$XDG_DATA_HOME/alloinit/`):

```sh
alloinit -l ./lib proj
```

Relink a project’s Allolib dependencies:

```sh
alloinit -u proj
```

Install Allolib dependencies to a directory without building a new project:

```sh
alloinit -l ./lib -L
```

### Description ###

[`alloinit`][alloinit] ([download][alloinit-download]) is a Bash script for
initializing Allolib projects based on [`allotemplate`][allotemplate]. It uses
symbolic links to share the Allolib dependencies—[`allolib`][allolib] itself as
well as [`al_ext`][al_ext], the stable Allolib extensions—between projects. It
also functions as a one-step project configuration tool. Starting and running a
new Allolib project is as easy as:

```sh
alloinit project
cd project
./run.sh
```

> If you don't want symlinked dependencies, then call `alloinit` with the `-N`
> flag, which adds `allolib` and `al_ext` as Git submodules. This will produce
> a traditional `allotemplate` project, but will take the normal amount of time
> to create and configure.

This creates a new Allolib project in the directory `project`. `allotemplate` is
available on the remote `allotemplate` if you need to pull changes from the
template later. The `init.sh` and `distclean.sh` scripts are
removed, since they conflict with `alloinit`, and `allolib` and `al_ext` are
added to the `.gitignore`.

A more detailed look at the state of `project` after it is created:

```sh
$ alloinit project
$ cd project
$ ls -AF
.git/           CMakeLists.txt  al_ext@         bin/            configure.sh*   run.sh*
.gitignore      README.md       allolib@        build/          debug.sh*       src/
$ readlink allolib al_ext
/home/user/.local/share/alloinit/allolib
/home/user/.local/share/alloinit/al_ext
$ git status
On branch master
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   .gitignore
	deleted:    distclean.sh
	deleted:    init.sh
no changes added to commit (use "git add" and/or "git commit -a")
$ git branch
* master
$ git remote
allotemplate
$ tail .gitignore
*.bmp
*.BMP
*.bin
*.binary

apps/

# allolib dependencies
/allolib
/al_ext
```

By default, `allolib` and `al_ext` are stored in `$XDG_DATA_HOME/alloinit/`, or
in `~/.local/share/alloinit/` if `$XDG_DATA_HOME` is not set or is empty. This
can be configured by passing `-l <lib_dir>`.

```sh
$ alloinit -l ~/workspace/lib ~/workspace/project
$ cd ~/workspace
$ ls -F
lib/     project/
$ cd project
$ ls -F
CMakeLists.txt  al_ext@         bin/            configure.sh*   run.sh*
README.md       allolib@        build/          debug.sh*       src/
$ readlink allolib al_ext
/home/user/workspace/lib/allolib
/home/user/workspace/lib/al_ext
```

Because `alloinit` uses symbolic links, the links to `allolib` and `al_ext` will
need to be redone if the actual locations of `allolib` or `al_ext` are changed.
Use `alloinit -r` for this:

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD014 -->
```sh
$ alloinit -r proj
```
<!-- markdownlint-restore -->

`alloinit` cleans up after itself if it’s closed early or if it encounters an
error. If either `allolib` or `al_ext` have not finished downloading with all of
their dependencies, then `alloinit` removes the partially-finished download. It
will also remove the partially-generated project. If `allolib` or `al_ext`
finish downloading, however, then they will remain in place (allowing you to
debug and try again without having to wait for them to download again).

#### Allolib dependency management ####

The Allolib dependencies in `<lib_dir>` can be updated with the `-u` flag.
Allolib dependencies can be installed to a `<lib_dir>` without setting up a new
project by passing the `-L` flag:

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD014 -->
```sh
$ alloinit -l ./lib -L  # Install Allolib dependencies to `./lib`.
$ alloinit -l ./lib -u  # Update Allolib dependencies in `./lib`.
```
<!-- markdownlint-restore -->

### Installation ###

Download [`alloinit`][alloinit-download] and move it to a directory on your
`PATH`. Make sure to set the executable bit. For example:

```sh
$ echo "$HOME"                    # Our home directory is `/home/user`.
/home/user
$ echo "$PATH"                    # `~/.local/bin` is in our `PATH`.
/home/user/.local/bin:/usr/local/bin:/usr/bin:/bin
$ curl https://allolib-s22.github.io/notes-ethwu/alloinit \
    > ~/.local/bin/alloinit       # Download `alloinit` to `~/.local/bin`.
$ chmod +x ~/.local/bin/alloinit  # Make `alloinit` executable.
$ alloinit -h                     # `alloinit` is now available!
```

Alternatively, just use the script directly:

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD014 -->
```sh
$ cd ~/workspace/allolib-projects/
$ curl https://allolib-s22.github.io/notes-ethwu/alloinit > alloinit
$ chmod +x alloinit
$ ./alloinit -h                   # Execute `alloinit` using `./alloinit`.
```
<!-- markdownlint-restore -->

[alloinit]: https://github.com/allolib-s22/notes-ethwu/blob/main/alloinit
[alloinit-download]: alloinit
[allolib]: https://github.com/AlloSphere-Research-Group/allolib
[al_ext]: https://github.com/AlloSphere-Research-Group/al_ext
[allotemplate]: https://github.com/AlloSphere-Research-Group/allotemplate

