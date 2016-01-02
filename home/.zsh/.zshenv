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

if [[ -e ${ZDOTDIR}/env/$(hostname) ]]; then
	source ${ZDOTDIR}/env/$(hostname)
fi


# Path
#--------------------
# Sets path in a way similar to path_helper(8) on OS X
# Takes each line of the following files and adds it to the path
#     ${prefix}/paths.d/${HOSTNAME}
#     ${prefix}/paths
#     /etc/paths
# Same goes for manpath (paths to manual pages), fpath (paths to zsh functions),
# and cdpath (paths whose contents can be cd'd to from anywhere)

typeset -U path manpath fpath cdpath

local prefix="${ZDOTDIR}/paths"

path=(
	${(ef)"$(cat ${prefix}/paths.d/${HOST} 2> /dev/null)"}
	${(ef)"$(cat ${prefix}/paths           2> /dev/null)"}
	${(ef)"$(cat /etc/paths                2> /dev/null)"}
	${path}
)

manpath=(
	${(ef)"$(cat ${prefix}/manpaths.d/${HOST} 2> /dev/null)"}
	${(ef)"$(cat ${prefix}/manpaths           2> /dev/null)"}
	${(ef)"$(cat /etc/manpaths                2> /dev/null)"}
	${manpath}
)

fpath=(
	${(ef)"$(cat ${prefix}/fpaths.d/${HOST} 2> /dev/null)"}
	${(ef)"$(cat ${prefix}/fpaths           2> /dev/null)"}
	${(ef)"$(cat /etc/fpaths                2> /dev/null)"}
	${fpath}
)

cdpath=(
	${(ef)"$(cat ${prefix}/cdpaths.d/${HOST} 2> /dev/null)"}
	${(ef)"$(cat ${prefix}/cdpaths           2> /dev/null)"}
	${(ef)"$(cat /etc/cdpaths                2> /dev/null)"}
	${cdpath}
)

export path manpath fpath cdpath
