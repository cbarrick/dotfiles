#!/usr/bin/env zsh

# Shell Options
#--------------------
# zshoptions(1)  /  http://zsh.sourceforge.net/Doc/Release/Options.html

# Changing Directories
# setopt auto_cd # If command is a directory path, cd to it.
setopt auto_pushd # cd is really pushd.
setopt chase_links # Resolve symbolic links to their true location.
setopt pushd_ignore_dups # Don't put duplicates on the directory stack.
setopt pushd_minus # Make `cd -1` go to the previous directory, etc.
setopt pushd_to_home # pushd with no arguments goes home, like cd.

# Completion
setopt auto_param_keys # Intelligently add a space after variable completion.
setopt auto_param_slash # Intelligently add a slash after directory completion.
setopt auto_remove_slash # Remove trailing slash if next char is a word delim.
setopt complete_aliases # Treat aliases as distinct commands.
setopt complete_in_word # Completions happen at the cursor's location.
setopt glob_complete # Tab completion expands globs.
setopt hash_list_all # Ensure the command path is hashed before completion.
setopt menu_complete # Expand first match and use the interactive menu.

# Expansion and Globbing
setopt glob # Enable globbing (i.e. the use of the '*' operator).
setopt extended_glob # Use additional glob operators ('#', '~', and '^').
setopt no_glob_dots # Require a leading '.' to be matched explicitly.
setopt mark_dirs # Mark directories resulting from globs with trailing slashes.
setopt nomatch # If a glob fails, the command isn't executed.

# History
setopt hist_ignore_all_dups # Ignore all duplicates when writing history.
setopt hist_ignore_space # Ignore commands that begin with spaces.
setopt inc_append_history # Write commands to history file as soon as possible.

# Input/Output
setopt append_create # Allow '>>' to create a file.
setopt no_clobber # Prevent `>` from clobbering files. Use `>!` to clobber.
setopt correct # Offer to correct the spelling of commands.
setopt interactive_comments # Allow comments in interactive shells.
setopt short_loops # Enable short loop syntax: `for <var> in <seq>; <command>`.

# Job Control
setopt auto_continue # When suspended jobs are disowned, resume them in the bg.
setopt auto_resume # Single-word simple commands are candidates for resumption.
setopt bg_nice # Run background jobs at lower priority.
setopt check_jobs # Warn about suspended jobs on exit.
setopt check_running_jobs # Warn about background jobs on exit.

# Scripts and Functions
setopt local_loops # Do not allow `break` etc. outside of loops.

# ZLE
setopt zle # Use ZLE.
setopt no_beep # Do not beep on ZLE errors (most beeps).


# Keyboard
#--------------------
# As much as possible, we use the terminfo database to lookup key code. This is
# the most portable. For key codes not in the terminfo databse, we use the codes
# from xterm as defaults. This should cover 99% of the cases.
#
# For this to work, it's critical that your terminal sets the TERM environment
# variable appropriately. This is usually `xterm-256color` by default, but it
# is often possible to find a more specific terminal type to enable advanced
# features.
#
# The original terminfo database only contained key codes for unmodified and
# shifted keys. The ncurses library includes extensions for Alt and Ctrl
# modifiers too.
#
# Documentation for the original terminfo capabilities can be browsed in the
# manual: `man terminfo`. The keycode capabilities start with 'k'.
#
# The ncurses source code documents their terminfo database. In particular, see
# the section "XTERM Extensions" for the Alt and Ctrl extensions.
# https://invisible-island.net/ncurses/terminfo.src-sections.html
#
# I found the following comment in ncurses terminfo.src which explains the
# mapping from modifiers to the xterm extensions.
#
#       Code     Modifiers
#     ---------------------------------
#        2       Shift
#        3       Alt
#        4       Shift + Alt
#        5       Control
#        6       Shift + Control
#        7       Alt + Control
#        8       Shift + Alt + Control
#     ---------------------------------
#
# As far as I can tell, the code column refers to both the capability name and
# the corresponding escape code, e.g. Alt+Left is kLFT3 and sends \e[1;3D, while
# Shift+Alt+Left is kLFT4 and sends \e[1;4D. (The capability names for Shift
# alone doesn't follow this pattern though).
#
# For iTerm2, even when you load the "xterm Defaults" keymap, the Alt key sends
# 9 instead of 3, so you'll have to manually change the key codes to match if
# you set TERM to `xterm-256color` (the default).
#
# Macbook don't have all of the usual PC keys, but iTerm2 lets you map certain
# key combinations to escape codes. Here are some that make the terminal feel
# like any other macOS app when TERM is `xterm-256color`:
#
#     ⌘ + ↑        =  PageUp    =  Esc + [5~
#     ⌘ + ↓        =  PageDown  =  Esc + [6~
#     ⌘ + ←        =  Home      =  Esc + OH  (xterm application mode)
#     ⌘ + →        =  End       =  Esc + OF  (xterm application mode)
#     ⌘ + ←Delete  =  Ctrl + U  =  Hex: 0x15 (^U) (bound to kill-whole-line by default)
#     ⌥ + ←Delete  =  Alt + ^?  =  Hex: 0x1b 0x7F (traditional Alt + Backspace)
#
# There's long been a debate about the behavior of the backspace key. The vt100
# emulated by xterm sends an ASCII BS (^H) while the vt220 emulated by the Linux
# virtual terminal sends an ASCII DEL (^?). Most modern terminals emulate xterm,
# *except* they send DEL for backspace. This allows applications use Ctrl-h and
# backspace as separate keys. We explicitly set backspace to ^? even though
# terminfo wants us to use ^H.

# The terminfo module exposes a hashmap, `$terminfo[CAP]`, which maps terminfo
# capabilities to their values. It also exposes a command `echoti` which echos
# terminfo values and handles those capabilities which take arguments.
# http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fterminfo-Module
zmodload zsh/terminfo

# Make sure that the terminal is in application mode when zle is active.
# Values from terminfo are only valid in application mode.
if [[ ${terminfo[smkx]} && ${terminfo[rmkx]} ]]
then
	function zle-line-init {
		echoti smkx
	}
	function zle-line-finish {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

# Create a hashmap from key names to their codes.
typeset -gA key

key['Home']=${terminfo[khome]}
key['End']=${terminfo[kend]}
key['Insert']=${terminfo[kich1]}
key['Delete']=${terminfo[kdch1]}
key['Up']=${terminfo[kcuu1]}
key['Down']=${terminfo[kcud1]}
key['Left']=${terminfo[kcub1]}
key['Right']=${terminfo[kcuf1]}

key['Shift-Home']=${terminfo[kHOM]}
key['Shift-End']=${terminfo[kEND]}
key['Shift-Insert']=${terminfo[kIC]}
key['Shift-Delete']=${terminfo[kDC]}
key['Shift-Up']=${terminfo[kUP]}
key['Shift-Down']=${terminfo[kDN]}
key['Shift-Left']=${terminfo[kLFT]}
key['Shift-Right']=${terminfo[kRIT]}

key['Alt-Home']=${terminfo[kHOM3]}
key['Alt-End']=${terminfo[kEND3]}
key['Alt-Insert']=${terminfo[kIC3]}
key['Alt-Delete']=${terminfo[kDC3]}
key['Alt-Up']=${terminfo[kUP3]}
key['Alt-Down']=${terminfo[kDN3]}
key['Alt-Left']=${terminfo[kLFT3]}
key['Alt-Right']=${terminfo[kRIT3]}

key['Shift-Alt-Home']=${terminfo[kHOM4]}
key['Shift-Alt-End']=${terminfo[kEND4]}
key['Shift-Alt-Insert']=${terminfo[kIC4]}
key['Shift-Alt-Delete']=${terminfo[kDC4]}
key['Shift-Alt-Up']=${terminfo[kUP4]}
key['Shift-Alt-Down']=${terminfo[kDN4]}
key['Shift-Alt-Left']=${terminfo[kLFT4]}
key['Shift-Alt-Right']=${terminfo[kRIT4]}

key['Ctrl-Home']=${terminfo[kHOM5]}
key['Ctrl-End']=${terminfo[kEND5]}
key['Ctrl-Insert']=${terminfo[kIC5]}
key['Ctrl-Delete']=${terminfo[kDC5]}
key['Ctrl-Up']=${terminfo[kUP5]}
key['Ctrl-Down']=${terminfo[kDN5]}
key['Ctrl-Left']=${terminfo[kLFT5]}
key['Ctrl-Right']=${terminfo[kRIT5]}

key['Shift-Ctrl-Home']=${terminfo[kHOM6]}
key['Shift-Ctrl-End']=${terminfo[kEND6]}
key['Shift-Ctrl-Insert']=${terminfo[kIC6]}
key['Shift-Ctrl-Delete']=${terminfo[kDC6]}
key['Shift-Ctrl-Up']=${terminfo[kUP6]}
key['Shift-Ctrl-Down']=${terminfo[kDN6]}
key['Shift-Ctrl-Left']=${terminfo[kLFT6]}
key['Shift-Ctrl-Right']=${terminfo[kRIT6]}

key['Alt-Ctrl-Home']=${terminfo[kHOM7]}
key['Alt-Ctrl-End']=${terminfo[kEND7]}
key['Alt-Ctrl-Insert']=${terminfo[kIC7]}
key['Alt-Ctrl-Delete']=${terminfo[kDC7]}
key['Alt-Ctrl-Up']=${terminfo[kUP7]}
key['Alt-Ctrl-Down']=${terminfo[kDN7]}
key['Alt-Ctrl-Left']=${terminfo[kLFT7]}
key['Alt-Ctrl-Right']=${terminfo[kRIT7]}

key['Shift-Alt-Ctrl-Home']=${terminfo[kHOM8]}
key['Shift-Alt-Ctrl-End']=${terminfo[kEND8]}
key['Shift-Alt-Ctrl-Insert']=${terminfo[kIC8]}
key['Shift-Alt-Ctrl-Delete']=${terminfo[kDC8]}
key['Shift-Alt-Ctrl-Up']=${terminfo[kUP8]}
key['Shift-Alt-Ctrl-Down']=${terminfo[kDN8]}
key['Shift-Alt-Ctrl-Left']=${terminfo[kLFT8]}
key['Shift-Alt-Ctrl-Right']=${terminfo[kRIT8]}

# Other keys:
# The traditional effect of the Alt-Key is to send Esc then Key.
key['Backspace']='^?'
key['Alt-Backspace']='\e^?'
key['PageUp']=${terminfo[kpp]}
key['PageDown']=${terminfo[knp]}
key['Tab']='\t'
key['Shift-Tab']=${terminfo[kcbt]}

# Key bindings:
# Now that our keycodes are defined, we actually bind them to ZLE widgets.
bindkey -e  # Default to emacs key bindings for many widgets.
[[ ${key['Home']}       ]] && bindkey ${key['Home']}       beginning-of-line
[[ ${key['End']}        ]] && bindkey ${key['End']}        end-of-line
[[ ${key['Insert']}     ]] && bindkey ${key['Insert']}     overwrite-mode
[[ ${key['Delete']}     ]] && bindkey ${key['Delete']}     delete-char
[[ ${key['Up']}         ]] && bindkey ${key['Up']}         up-line-or-search
[[ ${key['Down']}       ]] && bindkey ${key['Down']}       down-line-or-search
[[ ${key['Left']}       ]] && bindkey ${key['Left']}       backward-char
[[ ${key['Right']}      ]] && bindkey ${key['Right']}      forward-char
[[ ${key['Ctrl-Left']}  ]] && bindkey ${key['Ctrl-Left']}  backward-word
[[ ${key['Ctrl-Right']} ]] && bindkey ${key['Ctrl-Right']} forward-word
[[ ${key['Alt-Left']}   ]] && bindkey ${key['Alt-Left']}   backward-word
[[ ${key['Alt-Right']}  ]] && bindkey ${key['Alt-Right']}  forward-word
[[ ${key['Tab']}        ]] && bindkey ${key['Tab']}        menu-expand-or-complete
[[ ${key['Shift-Tab']}  ]] && bindkey ${key['Shift-Tab']}  reverse-menu-complete


# Prompt
#--------------------

# Load prompt functions.
autoload prompt_csb_setup
autoload prompt_csb_virtualenv_widget

# Load the promptinit system and set csb as the prompt theme.
autoload -Uz promptinit
promptinit
prompt csb

zstyle ':prompt_csb:*' main_color 243
zstyle ':prompt_csb:tmux:*' main_color blue
zstyle ':prompt_csb:*' info_color green
zstyle ':prompt_csb:*' alt_color blue
zstyle ':prompt_csb:*' err_color red
zstyle ':prompt_csb:*' max_cols 200

zstyle ':prompt_csb:*' widgets \
	prompt_csb_hostpath_widget \
	prompt_csb_bg_widget \
	prompt_csb_vcs_widget \
	prompt_csb_virtualenv_widget


# Colors
#--------------------

# Use the GNU `dircolors` command to set the `LS_COLORS` variable.
# Applies to GNU ls only.
eval $(dircolors ~/.dircolors)


# History
#--------------------
HISTSIZE=2000
SAVEHIST=${HISTSIZE}
HISTFILE=${ZDOTDIR}/.history
export HISTSIZE SAVEHIST HISTFILE


# Completion
#--------------------
autoload -Uz compinit
compinit -u

zstyle ':completion:*' use-cache true # Cache completion to `${ZDOTDIR}/.zcompcache`.
zstyle ':completion:*' menu 'select' # Make the menu interactive with arrow keys.


# Core utils
#--------------------
function exists {
	type $1 &> /dev/null
}

# Make the coreutils a bit nicer for interactive use.
alias sed="sed -r"
alias mkdir="mkdir -p"
alias grep="grep --extended-regexp"
alias ls="ls --human-readable --classify --group-directories-first --color=auto"
alias l="ls --format=long"
alias la="l --almost-all"
alias df="df -h --total"
alias du="du -h --total"
alias dd="dd status=progress bs=8M"
alias c="clear"

# System tools that should always use sudo
alias apt="sudo apt"
alias aptitude="sudo aptitude"
alias pacman="sudo pacman"
alias systemctl="sudo systemctl"
alias shutdown="sudo shutdown"
alias reboot="sudo reboot"

# Allow alias expansion with sudo
alias sudo="sudo "

# Use hub instead of git when avaliable
exists hub && alias git=hub

# Editors in order of preference, least to most
exists nano && EDITOR="nano"
exists vim  && EDITOR="vim"
exists atom && EDITOR="atom -w"
exists code && EDITOR="code -nw"
export EDITOR VISUAL="$EDITOR"

# Pager settings
PAGER="less"
LESS="-MSR"
export PAGER LESS

# Use paru instead of pacman
exists paru && alias pacman="paru"


# Rationalize Dots
#--------------------
# Automatically expands '....' to '../..'

function rationalize-dot {
	if [[ ${LBUFFER} = *... ]]
	then
		LBUFFER=${LBUFFER[1,-2]}
		LBUFFER+=/..
	else
		LBUFFER+=.
	fi
}
zle -N rationalize-dot
bindkey . rationalize-dot


# Word Characters
#--------------------
# Where do words break when using `backward-word` (alt-left) etc.
# This removes the '/' from the default.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export WORDCHARS


# Window Title
#--------------------

# Percent encode
function pct_encode {
	# Collect all arguments into a single string.
	local input="$(echo $@)"

	# Process the input byte-by-byte.
	local LC_ALL=C

	# Percent encode the input.
	local output=''
	local i ch hexch
	for i in {1..${#input}}
	do
		ch="${input[i]}"
		if [[ "${ch}" =~ [/._~A-Za-z0-9-] ]]
		then
			output+="${ch}"
		else
			hexch=$(printf "%02X" "'${ch}")
			output+="%${hexch}"
		fi
	done
	echo "${output}"
}

# Get the pwd as a `file://` URL, including the hostname.
function pwurl {
	echo "file://${HOST}$(pct_encode ${PWD})"
}

# Present working directory as a `file://` URL.
# This is updated by the chpwd hook.
export PWURL=$(pwurl)

# Sets the title to whatever is passed as $1
function set-term-title {
	# Escape the argument for printf formatting.
	local title=$1
	title=${title//\\/\\\\}
	title=${title//\"/\\\"}
	title=${title//\%/\%\%}

	# OSC 0, 1, and 2 are the portable escape codes for setting window titles.
	printf "\e]0;$title\a"  # Both tab and window
	printf "\e]1;$title\a"  # Tab title
	printf "\e]2;$title\a"  # Window title

	# OSC 6 and 7 are used on macOS to advertise host and pwd.
	# These codes may foobar other terminals on Linux, like gnome-terminal.
	if [[ ${TERM_PROGRAM} == 'Apple_Terminal' || ${LC_TERMINAL} == 'iTerm' ]]
	then
		print -n "\e]6;${PWURL}\a"  # Current document as a URL (Terminal.app)
		print -n "\e]7;${PWURL}\a"  # PWD as a URL (Terminal.app and iTerm2)
	fi

	# Also set window name in tmux.
	if [[ ${TMUX} ]]
	then
		tmux rename-window $title
	fi
}

# At the prompt, we set the title to "$HOST : $PWD".
function precmd-title {
	set-term-title "$(print ${HOST%%.*} : ${PWD/#${HOME}/\~})"
}

# When running a command, set the title to "$HOST : $COMMAND"
function preexec-title {
	set-term-title "$(print ${HOST%%.*} : $1)"
}

# Update PWURL whenever we change PWD
function chpwd-chpwurl {
	export PWURL=$(pwurl)
}

# Setup the hooks
autoload add-zsh-hook
add-zsh-hook precmd precmd-title
add-zsh-hook preexec preexec-title
add-zsh-hook chpwd chpwd-chpwurl


# iTerm2
#--------------------
# It's difficult to detect if we are using iTerm2 over an SSH session, because
# $TERM_PROGRAM may not be propagated. We source the iterm2 integration script
# regardless of what shell we are using, and hope nothing breaks.

source ${ZDOTDIR}/iterm2.zsh


# Python
#--------------------
# Note: DON'T auto activate conda. Conda environments can include all kinds of
# software that interferes with system software (e.g. ncurses). It's too much of
# a pain to always question if the binary you're using is the binary you expect.

export IPYTHONDIR="${HOME}/.ipython"
alias ipy="ipython --profile=csb"

alias python=python3
alias pip="python -m pip"
alias venv="python -m venv"


# Virtual Environments
#--------------------
# In theory, many different programming language tools use virtual environments
# as part of the standard dev setup. In practice, I mainly use Python's venv.
# This code could be generalized to more tools in the future.

function find_venv {
	local search=(
		"./.venv/bin/activate"  # python venv
	)
	for path in $search
	do
		if [[ -f "$path" ]]
		then
			echo "$path"
			return 0
		fi
	done
	return 1
}

function activate {
	# Source the activate script in a new subshell.
	zsh -c "source '$(find_venv)' && exec zsh -i"
}


# Rust
#--------------------

# Compile and print optimized assembly from rust source code.
function rust-asm { (
	# This function runs in a subshell and exits on any error.
	set -e

	# If we're in a crate root, ensure that it and its deps are built.
	[[ -e Cargo.toml ]] && cargo build --release

	# If we're in a crate root, list all the crates we can link against.
	# These are transformed into `--extern` arguments for `rustc`.
	if [[ -e Cargo.toml ]]
	then
		local extern_crates=$(
			ls target/release/deps \
			| grep '\.rlib$' \
			| sed 's#(lib(.+)-[0-9a-f]+\.rlib)#--extern=\2=./target/release/deps/\1#' \
		)
	else
		local extern_crates=''
	fi

	# Compile to /tmp/assembly.s
	# - Use the 2018 edition by default.
	# - Enable optimization level 3 (same as cargo release build).
	# - Don't clutter the output with debug info.
	# - Use Intel syntax for x86 assembly.
	# - Link against all extern crates that are available.
	rustc \
		--edition=2018 \
		--crate-type=lib \
		--emit=asm \
		-C opt-level=3 \
		-C debuginfo=0 \
		-C llvm-args=-x86-asm-syntax=intel \
		-o /tmp/assembly.s \
		${(f)extern_crates} \
		$RUSTFLAGS \
		$@

	# Read the assembly to stdout.
	# - Use c++filt to demangle symbols.
	# - Do some extra demangling with sed.
	# - Remove lines that start with a dot.
	cat /tmp/assembly.s \
	| c++filt \
	| sed 's/::[a-z0-9]+:$/:/' \
	| sed '/\s*\./d'

	# Cleanup.
	rm /tmp/assembly.s
) }


# Quick Calculator
#--------------------
# Use it like this:
#
#     $ calc 3 ^ 3
#     27
#

function calc {
	echo $@ | bc -l
}

alias 'calc'='noglob calc'


# Modular config files
#--------------------
# `(on)` means to sort the glob by name.
# `(N)` enables NULL_GLOB, i.e. no error if the glob generates nothing.

if [[ -e "${ZDOTDIR}/.zshrc.d" ]]
then
	for file in "${ZDOTDIR}/.zshrc.d/"*(onN)
	do
		source $file
	done
fi
