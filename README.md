/home/csb
=========

This is my home, built on [Zsh], [Git], and [Atom].

[Atom]: https://atom.io
[Git]: http://git-scm.com
[Zsh]: http://www.zsh.org

![zsh screenshot](./home/.zsh/zsh.png)

The font used in the screen-shot is the excellent [Source Code Pro][] from Adobe. The color scheme used is [Base16 Bright][] with the saturation pulled up to 100% for every color.

[Source Code Pro]: https://github.com/adobe/source-code-pro
[Base16 Bright]: http://chriskempson.github.io/base16/#bright


Installation
------------

Use the included zsh install script to symlink the dotfiles under your home directory.


### Setup Zsh

My Zsh config lives under `~/.zsh` rather than directly under the home directory. The `ZDOTDIR` environmental variable tells Zsh where to find its config and must be set to `~/.zsh` (the default is your home directory).

This can be set at compile time, in the global `zshenv` file, or by linking the local `.zshenv` to the default `ZDOTDIR`.

```sh
ln -s ~/.zsh/.zshenv $ZDOTDIR/.zshenv
```


### Configuring the path

Each line in the files `.zsh/paths/paths` and `.zsh/paths/paths.d/$HOST` are added to your `$PATH`. Likewise, similar files exist to customize your `$MANPATH`, `$FPATH`, and `$CDPATH`.
