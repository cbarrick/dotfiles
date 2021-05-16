#!/usr/bin/env zsh

echo ">>> Installing home <<<"

# The directory containing this script.
local base=${0:A:h}

# Directories that should be linked into $XDG_CONFIG_HOME.
# This maps dotfile directory name to XDG directory name.
local -A xdg_configs=(
    ['.vscode']='Code'
    ['.pypoetry']='pypoetry'
)

# Create a symbolic link.
# Prompt if the link does not exist.
function link {
    if [[ "$(readlink -f "$2")" != "$(readlink -f "$1")" ]]
    then
        ln -sTi "$1" "$2"
    fi
}

# Link in regular dotfiles.
for src in "$base"/.*(.N) "$base"/*/**/*(.ND)
do
    # Link the file. Skip if the link is already established.
    local dest=${src/$base/~}
    local dest_dir=${dest:h}
    echo " ${dest/$HOME/~}"
    mkdir -p "$dest_dir"
    link "$src" "$dest"
done

# Link in XDG configs.
# Make sure to reload zshenv, since the XDG variables may not be set yet.
source ~/.zsh/.zshenv
for dotdir xdgdir in ${(kv)xdg_configs}
do
    for src in "$base/$dotdir"/**/*(.ND)
    do
        # Link the file. Skip if the link is already established.
        local old="$base/$dotdir"
        local new="$XDG_CONFIG_HOME/$xdgdir"
        local dest=${src/$old/$new}
        local dest_dir=${dest:h}
        echo " ${dest/$HOME/~}"
        mkdir -p "$dest_dir"
        link "$src" "$dest"
    done
done

# Link `.zshenv` into the home directory.
link ~/.zsh/.zshenv ~/.zshenv

# Tell iTerm2 about its profile.
if [[ `uname` == 'Darwin' ]]
then
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2"
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi

# Set strict file permissions for SSH configs.
chmod 700 ~/.ssh
chmod 700 ~/.ssh/**/*(/)
chmod 600 ~/.ssh/**/*(^/)
