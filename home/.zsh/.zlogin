#!/usr/bin/env zsh

# Welcome message
#--------------------

if [[ -o interactive ]]
then
	echo "\r${USER} @ ${HOST}"
fi


# Modular config files
#--------------------
# Note `*(on)` means to sort the glob by name.

if [[ -e "${ZDOTDIR}/.zlogin.d" ]]
then
	for file in "${ZDOTDIR}/.zlogin.d/"*(on)
	do
		source $file
	done
fi
