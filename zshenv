#!/bin/zsh


# Universal environment
#--------------------

ZDOTDIR=${HOME}/.zsh.d
export ZDOTDIR


# Universal options
#--------------------

# Expansion and Globbing
setopt glob # Perform filename generation (i.e. the use of the * operator)
setopt extended_glob # Use additional glob operators
setopt mark_dirs # Directories resulting from globbing have trailing slashes
setopt no_nomatch # If a glob fails, use the literal string


# Path
#--------------------

# Sets path in a way similar to path_helper(8) on OS X
#   $(cmd)      : Value of executing cmd
#   ${(e)param} : Like ${param} but also expand parameters in content
#   ${(f)param} : Like ${param} but change '\n' to ' '
#   #"          : These comments fix Sublime Text syntax highlighting
typeset -U path manpath fpath

local userpaths="${ZDOTDIR}/paths"

path=(
	${(ef)"$(cat ${userpaths}/paths.d/${HOST} 2> /dev/null)"} #"
	${(ef)"$(cat ${userpaths}/paths 2> /dev/null)"} #"
	${(ef)"$(cat /etc/paths 2> /dev/null)"}
	${path}
)

manpath=(
	${(ef)"$(cat ${userpaths}/manpaths.d/${HOST} 2> /dev/null)"} #"
	${(ef)"$(cat ${userpaths}/manpaths 2> /dev/null)"} #"
	${(ef)"$(cat /etc/manpaths 2> /dev/null)"}
	${manpath}
)

fpath=(
	${(ef)"$(cat ${userpaths}/fpaths.d/${HOST} 2> /dev/null)"} #"
	${(ef)"$(cat ${userpaths}/fpaths 2> /dev/null)"} #"
	${(ef)"$(cat /etc/fpaths 2> /dev/null)"}
	${fpath}
)

cdpath=(
	${(ef)"$(cat ${userpaths}/cdpaths.d/${HOST} 2> /dev/null)"} #"
	${(ef)"$(cat ${userpaths}/cdpaths 2> /dev/null)"} #"
	${(ef)"$(cat /etc/cdpaths 2> /dev/null)"}
	${cdpath}
)

export path manpath fpath cdpath
