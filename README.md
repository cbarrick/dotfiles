:pineapple: Awesomesauce :metal:
================================

This is my home, built with [Zsh], [Git], and [Atom]. :house_with_garden:

[Atom]: https://atom.io
[Git]: http://git-scm.com
[Zsh]: http://www.zsh.org


Highlights
----------

- Zsh
	- Minimal yet functional prompt, with version control info where appropriate.
	- Modified zkbd plugin (for key maps) to be nicer on OS X.
	- Supports Terminall.app advanced features.
	- Easy setup for `path`, `manpath`, `fpath`, and `cdpath` on a per-host basis.
- Git
	- Global .gitignore, including `.DS_Store`.
- Atom
	- Hard tabs ([ftw][smarttabs])
	- [Base16 Tomorrow] Dark theme.


[Base16 Tomorrow]: http://chriskempson.github.io/base16/#tomorrow
[smarttabs]: http://www.emacswiki.org/SmartTabs


Installation
------------

This repository is compatible with [homesick], a tool to manage, version control, and symlink dotfiles.

```sh
homesick clone cbarrick/dotfiles
homesick link dotfiles
```

[homesick]: https://github.com/technicalpickles/homesick


### Configuring your path

My Zsh config sources its paths from files, like a portable version of the `path_helper` command in OS X with support for host dependent paths.

Each line in the files `.zsh/paths/paths` and `.zsh/paths/paths.d/${HOST}` are added to your `$PATH`. Likewise, similar files exist to customize your `$MANPATH`, `$FPATH`, and `$CDPATH`.


TODO
----

- [ ] Refactor Zsh features into plugins.
	- [ ] Pick a plugin system, or write one.
