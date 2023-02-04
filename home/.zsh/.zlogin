#!/usr/bin/env zsh

# Welcome message
#--------------------

if [[ -o interactive ]]
then
	echo "\r${USER} @ ${HOST}"
fi


# Modular config files
#--------------------
# `(on)` means to sort the glob by name.
# `(N)` enables NULL_GLOB, i.e. no error if the glob generates nothing.

if [[ -e "${ZDOTDIR}/.zlogin.d" ]]
then
	for file in "${ZDOTDIR}/.zlogin.d/"*(onN)
	do
		source $file
	done
fi
