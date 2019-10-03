#!/usr/bin/env zsh

# Global profile
#--------------------
# The global profile may make changes to the PATH,
# so we source it before setting our own PATHs.

if [[ -o login ]]
then
	emulate sh -c '. /etc/profile'
fi


# Modular config files
#--------------------
# Note `*(on)` means to sort the glob by name.

if [[ -e "${ZDOTDIR}/.zprofile.d" ]]
then
	for file in "${ZDOTDIR}/.zprofile.d/"*(on)
	do
		source $file
	done
fi
