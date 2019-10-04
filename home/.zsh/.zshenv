#!/usr/bin/env zsh

# Universal environment
#--------------------

# Prevent zsh from sourcing config files from /etc, except /etc/zshenv.
unsetopt global_rcs

# Locale
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LANGUAGE LC_ALL

# Local config files are placed under $ZDOTDIR
ZDOTDIR=${HOME}/.zsh
export ZDOTDIR


# Modular config files
#--------------------
# Note `*(on)` means to sort the glob by name.

if [[ -e "${ZDOTDIR}/.zshenv.d" ]]
then
	for file in "${ZDOTDIR}/.zshenv.d/"*(on)
	do
		source $file
	done
fi
