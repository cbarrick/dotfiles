#!/usr/bin/env zsh

# Link in files.
base=${0:A:h}  # The directory containing this script.
for src in "$base"/.*(.N) "$base"/*/**/*(.D)
do
    # Link the file. Skip if the link is already established.
    dest=${src/$base/~}
    dest_dir=${dest:h}
    mkdir -p "$dest_dir"
	if [[ "$(readlink -f $dest)" != "$(readlink -f $src)" ]]
	then
    	ln -si "$src" "$dest"
	fi
done

# Link `.zshenv` into the home directory.
if [[ "$(readlink -f ~/.zshenv)" != "$(readlink -f ~/.zsh/.zshenv)" ]]
then
	ln -si ~/.zsh/.zshenv ~/.zshenv
fi

# Tell iTerm2 about its profile.
if [[ `uname` == 'Darwin' ]]
then
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2"
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi
