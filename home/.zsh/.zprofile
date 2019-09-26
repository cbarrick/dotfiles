#!/bin/zsh

# Host-specific config
#--------------------

if [[ -e ${ZDOTDIR}/.zprofile.d/${HOST} ]]
then
	source ${ZDOTDIR}/.zprofile.d/${HOST}
fi
