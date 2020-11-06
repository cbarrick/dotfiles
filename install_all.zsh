#!/usr/bin/env zsh

base=${0:A:h}  # The directory containing this script.
for dir in "$base"/*(/)
do
    if [[ -x "$dir/install.zsh" ]]
    then
        dir_name=${dir:t}
        "$dir/install.zsh" $@
    fi
done
