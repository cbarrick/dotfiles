#!/bin/zsh

# Host-specific config
#--------------------
# For .zlogout, this should come *before* the general config.

if [[ -e ${ZDOTDIR}/.zlogout.d/${HOST} ]]
then
	source ${ZDOTDIR}/.zlogout.d/${HOST}
fi

