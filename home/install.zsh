#!/usr/bin/env zsh

# List of dotfiles or dotdirs that must be ignored.
# This is a failsafe to ensure these directories don't ever get entangled with
# the dotfiles repo and accidentally pushed to a public URL.
BLACKLIST=('.ssh')

# Link all dotfiles into the home directory.
for dotfile in ${0:A:h}/.*
do
	if (( ${BLACKLIST[(Ie)${dotfile:t}]} ))
	then
		echo WARNING: detected blacklisted dotfile or dotdir, skipping: ${dotfile:t}
		continue
	else
		ln -si ${dotfile:A} ${HOME}
	fi
done

# Link `.zshenv` into the home directory.
ln -si ~/.zsh/.zshenv ~/.zshenv

# Tell iTerm2 about its profile.
if [[ `uname` == 'Darwin' ]]
then
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2"
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi
