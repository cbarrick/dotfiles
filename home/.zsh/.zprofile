#!/usr/bin/env zsh

# Global profile
#--------------------
# The global profile may make changes to the PATH,
# so we source it before setting our own PATHs.

[[ -f '/etc/profile' ]] && emulate sh -c '. /etc/profile'
[[ -f '~/.profile'   ]] && emulate sh -c '. ~/.profile'


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
	${(ef)"$(cat ${prefix}/paths.d/*(.N) 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/paths         2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/paths.d/*(.N)      2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/paths              2> /dev/null < /dev/null)"}
	${path}
)

fpath=(
	${(ef)"$(cat ${prefix}/fpaths.d/*(.N) 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/fpaths         2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/fpaths.d/*(.N)      2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/fpaths              2> /dev/null < /dev/null)"}
	${fpath}
)

cdpath=(
	${(ef)"$(cat ${prefix}/cdpaths.d/*(.N) 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/cdpaths         2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/cdpaths.d/*(.N)      2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/cdpaths              2> /dev/null < /dev/null)"}
	${cdpath}
)

manpath=(
	${(ef)"$(cat ${prefix}/manpaths.d/*(.N) 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/manpaths         2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/manpaths.d/*(.N)      2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/manpaths              2> /dev/null < /dev/null)"}
	${manpath}
	''  # Empty string means to use the default search path.
)

infopath=(
	${(ef)"$(cat ${prefix}/infopaths.d/*(.N) 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/infopaths         2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/infopaths.d/*(.N)      2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/infopaths              2> /dev/null < /dev/null)"}
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


# Modular config files
#--------------------

if [[ -e "${ZDOTDIR}/.zprofile.d" ]]
then
	for file in "${ZDOTDIR}/.zprofile.d/"*
	do
		source $file
	done
fi
