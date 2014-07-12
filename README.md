:pineapple: Awesomesauce :metal:
================================

This is my home, built with [Zsh], [Git], and [Atom]. :house_with_garden:

[Atom]: https://atom.io
[Git]: http://git-scm.com
[Zsh]: http://www.zsh.org


Zsh
---

![zsh screenshot](./home/.zsh/zsh.png)

- Minimal prompt, with version control info where appropriate.
- Modified zkbd plugin (for key maps) that works better on OS X.
- Supports Terminal.app advanced features, like session resume.
- Easy setup for `path`, `manpath`, `fpath`, and `cdpath` on a per-host basis.

The font used in the screen-shot is the excellent [Source Code Pro][] from Adobe. The color scheme used is [Base16 Bright][] with the saturation pulled up to 100% for every color.

[Source Code Pro]: https://github.com/adobe/source-code-pro
[Base16 Bright]: http://chriskempson.github.io/base16/#bright


Atom
----
- Atom
	- Hard tabs ([ftw][smarttabs])
	- [Base16 Tomorrow] Dark theme.

[Base16 Tomorrow]: http://chriskempson.github.io/base16/#tomorrow
[smarttabs]: http://www.emacswiki.org/SmartTabs


Misc
----
- Git
	- Global `.gitignore` to keep OS level stuff like `.DS_Store` out of all repositories.


Installation
------------

This repository is compatible with [homesick], a tool to manage, version control, and symlink dotfiles.

```sh
homesick clone cbarrick/dotfiles
homesick link dotfiles
```

[homesick]: https://github.com/technicalpickles/homesick


### Setup Zsh

My Zsh config lives under `~/.zsh` rather than directly under the home directory. On most systems, you'll need to let Zsh know where to find its config files by setting the `$ZDOTDIR` environmental variable to `${HOME}/.zsh`.

If you have root access, find the global Zsh config (`/etc/zshenv` on OS X and `/etc/zsh/zshenv` on Debian and Arch iirc). Then add the following line somewhere:

```sh
export ZDOTDIR=${HOME}/.zsh
```

Alternatively, if you can't or don't want to modify global files, symlink `~/.zsh/.zshenv` as `~/.zshenv`:

```sh
ln -s ~/.zsh/.zshenv ~/.zshenv
```


### Configuring your path

My Zsh config sources its paths from files, like a portable version of the `path_helper` command in OS X with support for host dependent paths.

Each line in the files `.zsh/paths/paths` and `.zsh/paths/paths.d/${HOST}` are added to your `$PATH`. Likewise, similar files exist to customize your `$MANPATH`, `$FPATH`, and `$CDPATH`.
