#!/usr/bin/env zsh

# Welcome message
#--------------------

if [[ -o interactive ]]
then
	echo "\r${USER} @ ${HOST}"
fi


# Host-specific config
#--------------------

if [[ -e ${ZDOTDIR}/.zlogin.d/${HOST} ]]
then
	source ${ZDOTDIR}/.zlogin.d/${HOST}
fi
