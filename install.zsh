#!/usr/bin/env zsh
for dotfile in $0:A:h/home/*(D); do
	ln -s -i $dotfile:A $HOME/$dotfile:t
done
