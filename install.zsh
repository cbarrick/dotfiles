#!/usr/bin/env zsh

# Link all dotfiles into home directory
for dotfile in ${0}:A:h/home/*(D)
do
	ln -s -i ${dotfile:A} ${HOME}
done

# Tell iTerm2 about its profile
if [[ `uname` == 'Darwin' ]]
then
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm"
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi
