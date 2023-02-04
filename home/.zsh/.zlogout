#!/usr/bin/env zsh

# Modular config files
#--------------------
# `(On)` means to sort the glob by name IN REVERSE.
# `(N)` enables NULL_GLOB, i.e. no error if the glob generates nothing.

if [[ -e "${ZDOTDIR}/.zlogout.d" ]]
then
	for file in "${ZDOTDIR}/.zlogout.d/"*(OnN)
	do
		source $file
	done
fi
