/home/csb
==================================================

This is my home, built on [Zsh], [Git], and [Atom].

[Atom]: https://atom.io
[Git]: http://git-scm.com
[Zsh]: http://www.zsh.org

**TODO:** Get a more recent screenshot

![zsh screenshot](./home/.zsh/zsh.png)


## Installation

In the best case, you only need to run `install.zsh`. This will link all items in the `./home` directory into your home.

In some cases, you'll need to perform additional steps, given below.


### Configure `$ZDOTDIR`

My Zsh config lives under `~/.zsh` rather than directly under the home directory. The `$ZDOTDIR` environmental variable tells Zsh where to find its config and must be set to `~/.zsh` (the default for most installations is your home directory).

This can be set at compile time, in the global `zshenv` file, or by linking the included `.zshenv` into the current `$ZDOTDIR`.

```sh
ln -s ~/.zsh/.zshenv $ZDOTDIR/.zshenv
```


### Configure `$PATH`

These dotfiles have a simple way to set your `$PATH`, both globally and on a host-by-host basis. New paths can be added as lines in the files `.zsh/paths/paths` and `.zsh/paths/paths.d/$HOST`. Likewise, similar files exist to customize your `$MANPATH`, `$FPATH`, and `$CDPATH`.


### Configure iTerm2

iTerm2 needs to be told where to find it's configuration. The installation script will attempt to configure iTerm2 for you, but this can be iffy. To manually configure iTerm, go to **Preferences -> General** and check the box **Load preferences from a custom folder or URL** and specify `~/.iterm2` as the location.
