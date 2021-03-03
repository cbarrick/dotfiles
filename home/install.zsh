#!/usr/bin/env zsh

echo ">>> Installing home <<<"

# The directory containing this script.
local base=${0:A:h}

# Create a symbolic link.
# Prompt if the link does not exist.
function link {
    if [[ "$(readlink -f "$2")" != "$(readlink -f "$1")" ]]
    then
        ln -sTi "$1" "$2"
    fi
}

# Link in files.
for src in "$base"/.*(.N) "$base"/*/**/*(.D)
do
    # Link the file. Skip if the link is already established.
    echo " $(realpath "$src" --relative-to="$base")"
    dest=${src/$base/~}
    dest_dir=${dest:h}
    mkdir -p "$dest_dir"
    link "$src" "$dest"
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

# Link vscode settings.
if [[ `uname` == 'Darwin' ]]
then
    mkdir -p "$HOME/Library/Application Support/Code"
    link "$HOME/.vscode/User" "$HOME/Library/Application Support/Code/User"
else
    mkdir -p "$HOME/.config/Code"
    link "$HOME/.vscode/User" "$HOME/.config/Code/User"
fi

# Set strict file permissions for SSH configs.
chmod 700 ~/.ssh
chmod 700 ~/.ssh/**/*(/)
chmod 600 ~/.ssh/**/*(^/)
