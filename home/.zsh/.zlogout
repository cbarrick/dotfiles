#!/usr/bin/env zsh

# Modular config files
#--------------------
# Note `*(On)` means to sort the glob by name IN REVERSE.

if [[ -e "${ZDOTDIR}/.zlogout.d" ]]
then
	for file in "${ZDOTDIR}/.zlogout.d/"*(On)
	do
		source $file
	done
fi
