#!/bin/zsh


# Shell Options
#--------------------
# zshoptions(1)  /  http://zsh.sourceforge.net/Doc/Release/Options.html

# Changing Directories
setopt auto_cd # If command is a directory path, cd to it
setopt auto_pushd # cd is really pushd
setopt chase_dots # Resolve `..` directories to their true location
setopt chase_links # Resolve links to their true location
setopt pushd_ignore_dups # Don't put duplicates on the directory stack
setopt pushd_minus # Make `cd -1` go to the previous directory, etc
setopt pushd_to_home # pushd with no arguments goes home, like cd

# Completion
setopt auto_name_dirs # Parameters set to a path can be used as ~param
setopt auto_remove_slash # Remove trailing slash if next char is a word delim
setopt hash_list_all # Before completion, make sure entire path is hashed
setopt glob_complete # Expand globs upon completion
setopt complete_in_word # Completions happen at the cursor's location

# Expansion and Globbing
setopt glob # Perform filename generation (i.e. the use of the * operator)
setopt extended_glob # Use additional glob operators
# setopt glob_dots # Glob dotfiles
setopt mark_dirs # Directories resulting from globbing have trailing slashes
setopt nomatch # If a glob fails, the command isn't executed

# History
setopt hist_ignore_all_dups # Ignore all duplicates when writing history
setopt hist_ignore_space # Ignore commands that begin with spaces
setopt inc_append_history # Write commands to history file as soon as possible

# Input/Output
setopt no_clobber # Prevents `>` from clobbering files. Use `>|` to clobber.
setopt correct # Try to correct the spelling of commands
setopt interactive_comments # Allow comments in interactive shells

# Job Control
setopt auto_continue # When suspended jobs are disowned, resume them in the bg
setopt auto_resume # single-word simple commands are candidates for resumption
setopt bg_nice # Run background jobs at lower priority
setopt check_jobs # Warn about background & suspended jobs on exit
setopt monitor # Enable job control. This is default.

# Prompting
setopt prompt_cr # Print a \r before the prompt
setopt no_prompt_sp # Allow the prompt to overwrite the previous line
setopt prompt_subst # Substitute in parameter/command/arithmetic expansions

# ZLE
setopt no_beep # The shell shouldn't beep on ZLE errors (most beeps)
setopt zle # Use ZLE. This is default, but I like to be explicit


# History
#--------------------
HISTSIZE=2000
HISTFILE=${ZDOTDIR}/.history
SAVEHIST=${HISTSIZE}
export HISTSIZE HISTFILE SAVEHIST


# Keyboard
#--------------------
autoload -Uz zkbd
[[ ! -f ${ZDOTDIR}/zkbd/${TERM} ]] && zkbd
source ${ZDOTDIR}/zkbd/${TERM}

bindkey -e
[[ -n ${key[Home]}       ]] && bindkey ${key[Home]}       beginning-of-line
[[ -n ${key[End]}        ]] && bindkey ${key[End]}        end-of-line
[[ -n ${key[Insert]}     ]] && bindkey ${key[Insert]}     overwrite-mode
[[ -n ${key[Delete]}     ]] && bindkey ${key[Delete]}     delete-char
[[ -n ${key[Up]}         ]] && bindkey ${key[Up]}         up-line-or-search
[[ -n ${key[Down]}       ]] && bindkey ${key[Down]}       down-line-or-search
[[ -n ${key[Left]}       ]] && bindkey ${key[Left]}       backward-char
[[ -n ${key[Right]}      ]] && bindkey ${key[Right]}      forward-char
[[ -n ${key[Ctrl-Left]}  ]] && bindkey ${key[Ctrl-Left]}  backward-word
[[ -n ${key[Ctrl-Right]} ]] && bindkey ${key[Ctrl-Right]} forward-word
[[ -n ${key[Alt-Left]}   ]] && bindkey ${key[Alt-Left]}   backward-word
[[ -n ${key[Alt-Right]}  ]] && bindkey ${key[Alt-Right]}  forward-word


# Prompt
#--------------------
autoload -Uz promptinit && promptinit
prompt cbarrick


# Completion
#--------------------
autoload -Uz compinit && compinit -u

zstyle ':completion:*' use-cache true # Cache completion to `${ZDOTDIR}/.zcompcache`
zstyle ':completion:*' squeeze-slashes true # Strip slashes from directories
zstyle ':completion:*' menu select # Make the menu interactive with arrow keys

bindkey '^I' menu-expand-or-complete
bindkey '^[[Z' reverse-menu-complete


# Command checking
#--------------------
function exists {
	type $1 &> /dev/null
}


# Core utils
#--------------------
alias sed="sed -r"
alias mkdir="mkdir -p"
alias grep="grep --extended-regexp --color"
alias ls="ls --human-readable --classify --group-directories-first --color=auto"
alias l="ls --format=long"
alias la="l --almost-all"
alias df="df -h --total"
alias du="du -h --total"

# Use hub instead of git when avaliable
exists hub && alias git=hub

# Editors in order of preference, least to most
exists nano && EDITOR="nano"    && VISUAL="nano"
exists vim  && EDITOR="vim"     && VISUAL="vim"
exists atom && EDITOR="atom -w" && VISUAL="atom -w"
export EDITOR VISUAL

PAGER="less"
LESS="-MSR"
export PAGER LESS


# Rationalize Dots
#--------------------
function rationalize-dot {
	if [[ ${LBUFFER} = *.. ]]
	then
		LBUFFER=${LBUFFER[1,-1]}
		LBUFFER+=/..
	else
		LBUFFER+=.
	fi
}
zle -N rationalize-dot
bindkey . rationalize-dot


# Window Title
#--------------------

# Get the cwd as a "file:" URL, including the hostname.
# cwurl = Current Working URL
function cwurl {
	# Percent-encode the cwd
	# LANG=C to process text byte-by-byte.
	local pct_encoded_cwd=''
	{
		local i ch hexch LANG=C
		for ((i = 1; i <= ${#PWD}; ++i))
		do
			ch="${PWD}[i]"
			if [[ "${ch}" =~ [/._~A-Za-z0-9-] ]]
			then
				pct_encoded_cwd+="${ch}"
			else
				hexch=$(printf "%02X" "'${ch}")
				pct_encoded_cwd+="%%${hexch}"
			fi
		done
	}

	echo "file://${HOST}${pct_encoded_cwd}"
}

# Sets the title to whatever is passed as $1
function set-term-title {
	# OSC 0, 1, and 2 are the portable escape codes for setting window titles.
	printf "\e]0;${1}\a"  # Both tab and window
	printf "\e]1;${1}\a"  # Tab title
	printf "\e]2;${1}\a"  # Window title

	# When using tmux -CC integration with iTerm2,
	# tabs and windows must be named through tmux.
	if [[ -n ${TMUX} ]]
	then
		tmux rename-window ${1}
	fi
}

# Notify Terminals on macOS of PWD.
function set-apple-title {
	# OSC 6 and 7 are used on macOS to advertise user, host, and pwd.
	# These codes may foobar other terminals on Linux, like gnome-terminal.
	printf "\e]6;\a"          # Current document as a URL (Terminal.app)
	printf "\e]7;$(cwurl)\a"  # CWD as a URL (Terminal.app and iTerm2)
}

# At the prompt, we set the title to "$HOST : $PWD".
# We call `print -P` to use prompt expansion instead of variable expansion.
function precmd-title {
	set-term-title "$(print -P %m : %~)"
	if [[ ${TERM_PROGRAM} == 'Apple_Terminal' || ${TERM_PROGRAM} == 'iTerm.app' ]]
	then
		set-apple-title
	fi
}

# When running a command, set the title to "$HOST : $COMMAND"
# The command is passed as $1 to the preexec hook.
function preexec-title {
	set-term-title "$(print -P %M : $1)"
}

# Configure the hooks
autoload add-zsh-hook
add-zsh-hook precmd precmd-title
add-zsh-hook preexec preexec-title


# iTerm2
#--------------------
if [[ ${TERM_PROGRAM} == 'iTerm.app' ]]
then
	source ${ZDOTDIR}/iterm2.zsh
fi


# tmux
#--------------------
if [[ -n ${SSH_CONNECTION} ]]
then
	tmux -CC new -A -s default
fi


# Go
#--------------------
export GOPATH=${HOME}/.go
path=(${GOPATH}/bin ${path})
cdpath=(${GOPATH}/src ${GOPATH}/src/github.com/cbarrick ${cdpath})


# Python
#--------------------

# Use `csb` as the default conda environment.
# This helps keep the base env pristine.
exists conda && conda activate csb

export IPYTHONDIR="${HOME}/.ipython"
alias ipy="ipython3 --no-confirm-exit --no-term-title --classic"
alias ipylab="ipy --pylab"
alias python="python3"
alias pip="pip3"
