#!/bin/zsh

# Disable Global RCs
#--------------------
# Prevents zsh from reading config files from /etc, except for /etc/zshenv

unsetopt global_rcs


# Universal environment
#--------------------

ZDOTDIR=${HOME}/.zsh
export ZDOTDIR


# Host-specific envirnonment
#--------------------

if [[ -e ${ZDOTDIR}/env/$(hostname) ]]
then
	source ${ZDOTDIR}/env/$(hostname)
fi


# Locale
#--------------------

LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LANGUAGE LC_ALL


# Path
#--------------------
# Sets path in a way similar to path_helper(8) on OS X.
#
# Each line of the path files and are added to the path. Lines may include
# variable substitutions and globs. The OS X standard locations for path files
# are /etc/paths and /etc/paths.d/*. We extend this to allow local path files at
# ${ZDOTDIR}/paths/paths and ${ZDOTDIR}/paths/paths.d/${HOST}.
#
# We do the same for manpath, fpath, and cdpath.

typeset -U path manpath fpath cdpath

local prefix="${ZDOTDIR}/paths"

path=(
	${(ef)"$(cat ${prefix}/paths.d/${HOST} 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/paths           2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/paths.d/*(.N)        2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/paths                2> /dev/null < /dev/null)"}
	${path}
)

manpath=(
	${(ef)"$(cat ${prefix}/manpaths.d/${HOST} 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/manpaths           2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/manpaths.d/*(.N)        2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/manpaths                2> /dev/null < /dev/null)"}
	${manpath}
)

fpath=(
	${(ef)"$(cat ${prefix}/fpaths.d/${HOST} 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/fpaths           2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/fpaths.d/*(.N)        2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/fpaths                2> /dev/null < /dev/null)"}
	${fpath}
)

cdpath=(
	${(ef)"$(cat ${prefix}/cdpaths.d/${HOST} 2> /dev/null < /dev/null)"}
	${(ef)"$(cat ${prefix}/cdpaths           2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/cdpaths.d/*(.N)        2> /dev/null < /dev/null)"}
	${(ef)"$(cat /etc/cdpaths                2> /dev/null < /dev/null)"}
	${cdpath}
)

export path manpath fpath cdpath
