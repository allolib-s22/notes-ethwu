#! /bin/bash

# Propagate non-zero error codes in pipelines.
set -o pipefail

# Usage information.
usage="$0
Start a new allolib project.

Usage: $0 [options...] <dir>

Creates a new allolib project in the directory <dir> as a clone of allotemplate. \
Projects created using $0 share dependencies, obviating the need to clone \
submodules every time you need to start a new project. The created project will \
have allotemplate set to its own remote, allowing you to specify a different \
origin remote.

$0 uses symbolic links in order to connect the project directory to the shared \
allolib dependencies. The generated symbolic links will point to absolute paths. \
If the allolib dependency directory is moved, generated symbolic links will have \
to be remade manually.

Options:
    -l <lib_dir>    Specify the directory to install allolib dependencies to.
    -h              Show this help text."

function show_usage() {
    width="$(tput cols)"
    echo "$usage" | fold -s -w $((width > 80 ? 80 : width))
}

if [[ $# -lt 1 ]] ; then
    show_usage
    exit 0
fi

# Positional arguments.
args=()
while [[ $OPTIND -le $# ]] ; do
    if getopts 'l:h' opt ; then
        case "$opt" in
            l)
                lib="$OPTARG"
                ;;
            h)
                show_usage
                exit 0
                ;;
            ?)
                exit 1
                ;;
        esac
    else
        # Store positional argument.
        args+=("${!OPTIND}")
        ((OPTIND++))
    fi
done

# Directory to set up allolib project in.
dest="${args[0]}"
# Directory to keep shared dependencies.
lib="${lib:-"$(dirname "$dest")/lib"}"
# Whether the dependency directory already existed before running the script.
lib_exists="$(test -d "$lib" ; echo $?)"
# Dependencies shared between allolib projects.
deps=(
    allolib
    al_ext
)

# Temporary file to indicate that directory was created by alloinit.
tmpfile=.alloinit.tmp

# Clean up in case of early abort.
function cleanup() {
    >&2 echo "Could not finish; cleaning up."
    for dep in "${deps[@]}" ; do
        if [[ -f "$lib/.$dep$tmpfile" ]] ; then
            >&2 echo "Removing dependency \`$lib/$dep\`."
            rm -rf "$lib/$dep" "$lib/.$dep$tmpfile"
        fi
    done

    # Remove lib if it did not exist prior to running alloinit.
    [[ -d "$lib" ]] && ! [[ "$lib_exists" -eq 0 ]] && rmdir "$lib"

    if [[ -f "$dest/$tmpfile" ]] ; then
        >&2 echo "Removing project \`$dest\`."
        rm -rf "$dest"
    fi
}

function onexit() {
    if [[ $? -gt 0 ]] ; then
        cleanup
    fi

    rm -f "$dest/$tmpfile"
}

# Indent the output of subcommands and send output to stderr.
function indent() {
    sed -ur "s/(^|\r)/\1\t/g" >&2
}

trap onexit EXIT

if [[ -d "$dest" ]] ; then
    >&2 echo "Directory \`$dest\` already exists."
    exit 1
fi

>&2 echo "Initializing allolib project in \`$dest\`:"
mkdir -p "$dest" || exit $?
touch "$dest/$tmpfile" || exit $?
git clone --bare git@github.com:Allosphere-Research-Group/allotemplate.git "$dest/.git" \
    --progress 2>&1 | indent || exit $?
git_flags=(--git-dir "$dest/.git" --work-tree "$dest")
git "${git_flags[@]}" config core.bare false 2>&1 | indent || exit $?
git "${git_flags[@]}" checkout 2>&1 | indent || exit $?
# This command faces a fatal error unsetting remote.allotemplate.fetch, but
# otherwise seems to succeed.
git "${git_flags[@]}" remote rename origin allotemplate 2>&1 | indent # || exit $?

printf "\n\n# Allolib Dependencies\n" >> "$dest/.gitignore"
mkdir -p "$lib" || exit $?
for dep in "${deps[@]}" ; do
    if [[ ! -d "$lib/$dep" ]] ; then
        touch "$lib/.$dep$tmpfile" || exit $?
        >&2 echo "Retrieving dependency \`$dep\`:"
        git clone "git@github.com:Allosphere-Research-Group/$dep.git" "$lib/$dep" \
            --recurse-submodules \
            --progress 2>&1 | indent || exit $?
        rm -f "$lib/.$dep$tmpfile" || exit $?
    fi
    loc="$(readlink -f "$lib/$dep")" || exit $?
    >&2 echo "Linking dependency \`$dep\` to \`$loc\`."
    ln -s "$loc" "$dest" || exit $?
    printf "/$dep\n" >> "$dest/.gitignore"
done

>&2 echo 'Configuring allolib project.'
(cd "$dest" && ./configure.sh ) || exit $?

>&2 echo 'Removing unusable scripts (init.sh; distclean.sh).'
rm "$dest/"{init,distclean}.sh || exit $?

>&2 echo "Allolib project initialized successfully in \`$dest\`."

