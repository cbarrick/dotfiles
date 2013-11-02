#!/bin/zsh


# Universal environment
#--------------------

ZDOTDIR=${HOME}/.zsh.d
ZLIBS=${ZDOTDIR:-${HOME}/.zsh.d}/zlibs
export ZDOTDIR ZLIBS


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
typeset -U path manpath fpath
local newpath
path=($(/bin/cat /etc/paths 2> /dev/null) ${path})
manpath=($(/bin/cat /etc/manpaths 2> /dev/null) ${manpath})
fpath=($(/bin/cat /etc/fpaths 2> /dev/null) ${fpath})
for file in /etc/paths ${ZLIBS}/paths.d/* ${ZLIBS}/paths.d/${OSTYPE}/*; do
    path=(${~$(/bin/cat ${file} 2> /dev/null)} $path)
done
for file in /etc/manpaths ${ZLIBS}/manpaths.d/* ${ZLIBS}/manpaths.d/${OSTYPE}/*; do
    manpath=(${~$(/bin/cat ${file} 2> /dev/null)} $manpath)
done
for file in /etc/fpaths ${ZLIBS}/fpaths.d/* ${ZLIBS}/fpaths.d/${OSTYPE}/*; do
    fpath=(${~$(/bin/cat ${file} 2> /dev/null)} $fpath)
done
export path manpath fpath
