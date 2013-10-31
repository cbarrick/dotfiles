#!/bin/zsh

# Set the location of local configuration files
ZDOTDIR=${HOME}/.zsh.d
export ZDOTDIR

# Set the path and manpath
typeset -U path manpath
path=(${HOME}/.local/bin ${path})
manpath=(${HOME}/.local/man ${manpath})
case ${OSTYPE} in
    (darwin*)
        if [[ -x /usr/libexec/path_helper ]]; then
            eval $(/usr/libexec/path_helper -s)
        fi
        ;;
    (linux*)
        # I need to add path stuff here
        ;;
esac
export path manpath

# In cygwin, everything must be setup from scratch. Use the configuration from
# the standard bash installation. This is a performance hit for scripts, but
# honestly how many zsh scripts will I be running in Windows
if [[ ${OSTYPE} == cygwin ]]
then
    # Source the global Cygwin profile
    # This sets up the path on Cygwin and other important tasks
    source /etc/profile
fi

# Set the number of open file descriptors to be 1024
# This is needed to build Android from source
ulimit -S -n 1024
