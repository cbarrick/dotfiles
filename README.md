There's no place like `$HOME`
==================================================

This is my home, built on [Zsh], [Git], and [Atom].

[Atom]: https://atom.io
[Git]: http://git-scm.com
[Zsh]: http://www.zsh.org

**TODO:** Get a recent screenshot


## Installation

Configs are separated into a few groups:

- **Main** dotfiles live in `home/*`. These dot files are linked directly into your home directory.

- **Misc** config files live in `misc/*`. These files don't necessarily belong in your home directory (e.g. global config files) or on every system (e.g. OS-specific).

Each directory contains an install script, e.g. `home/install.zsh`, that will link or copy their respective dotfiles into the proper locations. These scripts may also perform additional installation actions, like telling iTerm2 where to find its files.

You can run all of the install scripts using the top-level install script:

```sh
$ ./install_all.zsh
```


## Configuration

### Setup your terminal emulator

Certain features of the Zsh config, like the `PATH` setup, are only set for login shells. On some terminals, you must manually flip a switch to launch your shell as a login shell. This applies to `gnome-terminal`. If your terminal is configured to run Zsh as a custom command on startup, ensure that it starts Zsh as a login shell with `zsh -l`.

### Configure the prompt

The prompt looks like this:

```
╭────────────────────────────────────[ master ]──[ csb @ roronoa : ~/dotfiles ]
╰ $
```

The pieces surrounded by brackets are called prompt *widgets*. A widget is just a function that outputs some text to include in the prompt. To add a new widget, simply write the widget function and add it to the `widgets` style. The widgets are evaluated every time the prompt is drawn. No space is allocated for the widget if it produces no output.

The builtin widgets are:

- `prompt_csb_hostpath_widget` prints your username, hostname, and current working directory.
- `prompt_csb_vcs_widget` prints your current VCS branch and additional info when relevant. It is hidden when you are outside of a version controlled directory.
- `prompt_csb_bg_widget` prints the number of background jobs. It is hidden when you have no background jobs.

The prompt is configured with `zstyle` in `.zshrc`. Below is a list of the available configuration options and their defaults:

```sh
# Prompt widgets
zstyle ':prompt_csb:*' widgets \
    prompt_csb_hostpath_widget \
    prompt_csb_vcs_widget \
    prompt_csb_bg_widget

# Prompt colors
zstyle ':prompt_csb:local:*' main_color 243
zstyle ':prompt_csb:ssh:*' main_color blue
zstyle ':prompt_csb:*' info_color green
zstyle ':prompt_csb:*' alt_color blue
zstyle ':prompt_csb:*' err_color red
```

The `zstyle` command takes three(-ish) arguments: a _context pattern_, a _style name_, and one or more _values_. The context pattern determines when the given value applies to the style. The context always starts with `:prompt_csb` followed by either `:local` when working on your localhost or `:ssh` when connected to a remote machine. Passing multiple values sets them all as an array value for the style.

There are four colors that can be configured.

- `main_color` is the primary color of the prompt. The default 243 is a shade of dark gray.
- `info_color` is used to draw things like your git branch.
- `alt_color` is used to draw secondary information, e.g. a notification that you're dealing with merge conflicts.
- `err_color` overrides the main color if the previous command exited with a non-zero status.


### Extending the `PATH`

The `PATH` is set in a way similar to the default `path_helper(8)` on macOS.

The `PATH` is determined by the lines of so-called path files. These lines may include parameter substitutions and globs. Path files are read in the following order:

1. `/etc/paths`
2. `/etc/paths.d/*` (in lexicographic order)
3. `~/.zsh/paths/paths`
4. `~/.zsh/paths/paths.d/*` (in lexicographic order)

A similar process applies for `MANPATH`, `FPATH`, and `CDPATH` as well.

You can add a new directory to the path by creating a new path file:

```sh
$ echo '/some/path/to/foo/bin' > ~/.zsh/paths/paths.d/foo
$ exec zsh -l  # Reload your shell
```

### Configuring iTerm2

iTerm2 needs to be told where to find it's configuration. The installation script will attempt to handle this for you. If it fails, go to the preferences panel in iTerm2 and set it to load preferences from `~/.iterm2`.
