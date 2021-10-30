#!/usr/bin/env zsh

# Global profile
#--------------------
# The global profile may make changes to the PATH,
# so we source it before setting our own PATHs.

[[ -f '/etc/profile' ]] && emulate sh -c '. /etc/profile'
[[ -f '~/.profile'   ]] && emulate sh -c '. ~/.profile'


# Functions
#--------------------
# Most custom functions belong in zshrc instead.

# Better than cat for reading lines into variables.
# - Does not spawn a process.
# - Never writes to stderr.
# - Never reads from stdin.
function fastcat {
	for p in $@
	do
		[[ -f $p ]] && < $p
	done
}


# Path
#--------------------
# Sets `PATH` in a way similar to `path_helper(8)` on macOS.
#
# The `PATH` is determined by the lines of so-called path files. These lines
# may include parameter substitutions and globs. Paths files are read in the
# following order:
#
# 1. /etc/paths
# 2. /etc/paths.d/*
# 3. $ZDOTDIR/paths/paths
# 4. $ZDOTDIR/paths/paths.d*
#
# This logic is extended for other types of path variables as well.
#
# Any additional path manipulation which requires scripting (e.g. checking the
# hostname) should be placed in `$ZDOTDIR/.zprofile.d`.

# `-T` creates a "tied" array. `-U` causes the array to discard duplicates.
# In a tied array, the contents of the array are reflected into a `:`-separated
# string. The first arg names the string; the second arg names the array.
typeset -UT PATH path
typeset -UT FPATH fpath
typeset -UT CDPATH cdpath
typeset -UT MANPATH manpath
typeset -UT INFOPATH infopath

local prefix="${ZDOTDIR}/paths"

path=(
	${(ef)"$(fastcat ${prefix}/paths.d/*(.N))"}
	${(ef)"$(fastcat ${prefix}/paths)"}
	${(ef)"$(fastcat /etc/paths.d/*(.N))"}
	${(ef)"$(fastcat /etc/paths)"}
	${path}
)

fpath=(
	${(ef)"$(fastcat ${prefix}/fpaths.d/*(.N))"}
	${(ef)"$(fastcat ${prefix}/fpaths)"}
	${(ef)"$(fastcat /etc/fpaths.d/*(.N))"}
	${(ef)"$(fastcat /etc/fpaths)"}
	${fpath}
)

cdpath=(
	${(ef)"$(fastcat ${prefix}/cdpaths.d/*(.N))"}
	${(ef)"$(fastcat ${prefix}/cdpaths)"}
	${(ef)"$(fastcat /etc/cdpaths.d/*(.N))"}
	${(ef)"$(fastcat /etc/cdpaths)"}
	${cdpath}
)

manpath=(
	${(ef)"$(fastcat ${prefix}/manpaths.d/*(.N))"}
	${(ef)"$(fastcat ${prefix}/manpaths)"}
	${(ef)"$(fastcat /etc/manpaths.d/*(.N))"}
	${(ef)"$(fastcat /etc/manpaths)"}
	${manpath}
	''  # Empty string means to use the default search path.
)

infopath=(
	${(ef)"$(fastcat ${prefix}/infopaths.d/*(.N))"}
	${(ef)"$(fastcat ${prefix}/infopaths)"}
	${(ef)"$(fastcat /etc/infopaths.d/*(.N))"}
	${(ef)"$(fastcat /etc/infopaths)"}
	${infopath}
	''  # Empty string means to use the default search path.
)

export path fpath cdpath manpath infopath
export PATH FPATH CDPATH MANPATH INFOPATH


# Locale
#--------------------

LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LANGUAGE LC_ALL


# Personal dictionary
#--------------------

DICTIONARY="${HOME}/.dictionary.txt"
export DICTIONARY


# Modular config files
#--------------------

if [[ -e "${ZDOTDIR}/.zprofile.d" ]]
then
	for file in "${ZDOTDIR}/.zprofile.d/"*
	do
		source $file
	done
fi
