## `alloinit`

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

This creates a new Allolib project in the directory `project`. `project` is a
clone of the `allotemplate` repository, complete with history and branches.
However, the remote `origin` is unset, allowing you to connect `project` to your
own Git remote. `allotemplate` remains available on an eponymous remote,
allowing you to pull updates. The `init.sh` and `distclean.sh` scripts are
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
  glv
  legacy
  lighting
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

`alloinit` cleans up after itself if it’s closed early or if it encounters an
error. If either `allolib` or `al_ext` have not finished downloading with all of
their dependencies, then `alloinit` removes the partially-finished download. It
will also remove the partially-generated project. If `allolib` or `al_ext`
finish downloading, however, then they will remain in place (allowing you to
debug and try again without having to wait for them to download again).

[alloinit]: https://github.com/allolib-s22/notes-ethwu/blob/main/alloinit
[alloinit-download]: alloinit
[allolib]: https://github.com/AlloSphere-Research-Group/allolib
[al_ext]: https://github.com/AlloSphere-Research-Group/al_ext
[allotemplate]: https://github.com/AlloSphere-Research-Group/allotemplate

