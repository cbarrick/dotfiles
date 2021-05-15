#!/usr/bin/env zsh

# Universal environment
#--------------------

# Prevent zsh from sourcing config files from /etc, except /etc/zshenv.
unsetopt global_rcs

# Local config files are placed under $ZDOTDIR
ZDOTDIR=${HOME}/.zsh
export ZDOTDIR


# XDG Base Directory Spec
#--------------------
# Setup the XDG base directory environment variables.

# The macOS File System Programming Guide is slightly different from the XDG
# specs, but not totally incompatible. I used the values from the `xdg` Go
# library [1] for sensible defaults. These are compatible with the dotfiles I
# have checked into my dotfile repo.
#
# [1]: https://github.com/adrg/xdg/blob/master/README.md

# Note that the HOME version of these variable is the default path and the DIRS
# version defines additional search paths, like where the system wide config
# could be found.

if [[ $(uname) == "Darwin" ]]
then
	# Config
	XDG_CONFIG_HOME="$HOME/Library/Application Support"
	XDG_CONFIG_DIRS="$HOME/Library/Preferences:/Library/Application Support:/Library/Preferences"

	# Date
	XDG_DATA_HOME="$HOME/Library/Application Support"
	XDG_DATA_DIRS="/Library/Application Support"

	# State, cache, and runtime
	XDG_STATE_HOME="$HOME/Library/Application Support"
	XDG_CACHE_HOME="$HOME/Library/Caches"
	XDG_RUNTIME_DIR="$TMPDIR"
else
	# Config
	XDG_CONFIG_HOME="$HOME/.config"
	XDG_CONFIG_DIRS="/etc/xdg"

	# Data
	XDG_DATA_HOME="$HOME/.local/share"
	XDG_DATA_DIRS="/usr/local/share/:/usr/share/"

	# State, cache, and runtime
	XDG_STATE_HOME="$HOME/.local/state"
	XDG_CACHE_HOME="$HOME/.cache"
	XDG_RUNTIME_DIR="/run/user/$UID"
fi


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
