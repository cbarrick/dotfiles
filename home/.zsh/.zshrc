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
# setopt noclobber # Prevents `>` from clobbering files. Use `>|` to clobber.
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
setopt prompt_sp # Preserve lines that would be covered by the \r
setopt prompt_subst # Substitute in parameter/command/arithmetic expansions

# ZLE
# setopt no_beep # The shell shouldn't beep on ZLE errors (most beeps)
setopt zle # Use ZLE. This is default, but I like to be explicit


# History
#--------------------
HISTSIZE=2000
HISTFILE=${ZDOTDIR}/.history
SAVEHIST=$HISTSIZE
export HISTSIZE HISTFILE SAVEHIST


# Keyboard
#--------------------
autoload -Uz zkbd
[[ ! -f ${ZDOTDIR}/zkbd/${TERM} ]] && zkbd
source ${ZDOTDIR}/zkbd/${TERM}

bindkey -e
[[ -n "${key[Home]}"       ]] && bindkey "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"        ]] && bindkey "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"     ]] && bindkey "${key[Insert]}"     overwrite-mode
[[ -n "${key[Delete]}"     ]] && bindkey "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"         ]] && bindkey "${key[Up]}"         up-line-or-search
[[ -n "${key[Down]}"       ]] && bindkey "${key[Down]}"       down-line-or-search
[[ -n "${key[Left]}"       ]] && bindkey "${key[Left]}"       backward-char
[[ -n "${key[Right]}"      ]] && bindkey "${key[Right]}"      forward-char
[[ -n "${key[Ctrl-Left]}"  ]] && bindkey "${key[Ctrl-Left]}"  backward-word
[[ -n "${key[Ctrl-Right]}" ]] && bindkey "${key[Ctrl-Right]}" forward-word


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


# Core utils
#--------------------
alias sed="sed -r"
alias mkdir="mkdir -p"
alias grep="grep --extended-regexp --color"
alias ls="ls --human-readable --classify --group-directories-first --color=auto"
alias l="ls --format=long"
alias la="l --almost-all"

# Use hub instead of git when avaliable
[[ -a $(which hub 2> /dev/null) ]] && alias git=hub

[[ -a $(which atom 2> /dev/null) ]] && EDITOR="atom -w" || EDITOR="vim"
[[ -a $(which atom 2> /dev/null) ]] && VISUAL="atom -w" || VISUAL="vim"
PAGER="less"
export EDITOR VISUAL PAGER


# Rationalize Dots
#--------------------
function rationalize-dot {
	if [[ $LBUFFER = *.. ]]; then
		LBUFFER=$LBUFFER[1,-1]
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
		for ((i = 1; i <= ${#PWD}; ++i)); do
			ch="$PWD[i]"
			if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
				pct_encoded_cwd+="$ch"
			else
				hexch=$(printf "%02X" "'$ch")
				pct_encoded_cwd+="%%$hexch"
			fi
		done
	}

	echo "file://$HOST$pct_encoded_cwd"
}

# Sets the terminal tital
function set_term_title {
	# Titles are set with this escape sequence: "\e]$TYPE;$TITLE\a"
	printf "\e]0;\a"         # - type 0: ??
	printf "\e]1;$HOST\a"    # - type 1: Tab title
	printf "\e]2;\a"         # - type 2: Window title
	printf "\e]3;\a"         # - type 3: ??
	printf "\e]4;\a"         # - type 4: ??
	printf "\e]5;\a"         # - type 5: ??
	printf "\e]6;\a"         # - type 6: Current document as a URL (e.g. set by editors)
	printf "\e]7;$(cwurl)\a" # - type 7: CWD as a URL
}

autoload add-zsh-hook
add-zsh-hook precmd set_term_title


# iTerm2
#--------------------
source $ZDOTDIR/iterm2.zsh


# Go
#--------------------
export GOPATH=${HOME}/.go
path=(${GOPATH}/bin ${path})
cdpath=(${GOPATH}/src ${GOPATH}/src/github.com/cbarrick ${cdpath})


# Python
#--------------------
export IPYTHONDIR="${HOME}/.ipython"
alias ipy="ipython3 --no-confirm-exit --no-term-title --classic"
alias ipylab="ipy --pylab"
alias python="python3"
alias pip="pip3"

# Use `csb` as the default conda environment.
# This helps keep the root env pristine.
source activate csb


# Startup
#--------------------
print "\r${USER} @ ${HOST}"
