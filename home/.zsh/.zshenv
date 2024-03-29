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
# specs, but it's not totally incompatible. I used the values from the `xdg` Go
# library [1] for sensible defaults. These are compatible with the dotfiles I
# have checked into my dotfile repo.
#
# The macOS values can't really be customized. Some software (like pypoetry)
# does not check the `XDG_*` variables on macOS. So for the sake of portability
# among my personal scripts, these must match what that software expects.
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
# `(on)` means to sort the glob by name.
# `(N)` enables NULL_GLOB, i.e. no error if the glob generates nothing.

if [[ -e "${ZDOTDIR}/.zshenv.d" ]]
then
	for file in "${ZDOTDIR}/.zshenv.d/"*(onN)
	do
		source $file
	done
fi
