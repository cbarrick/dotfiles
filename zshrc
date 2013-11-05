#!/bin/zsh


# Shell Options. See zshoptions(1) or online at
# http://zsh.sourceforge.net/Doc/Release/Options.html
#--------------------

# Changing Directories
setopt chase_links # Resolve links to their true directory

# Completion
setopt auto_list # List choices on ambiguous completion
setopt auto_name_dirs # Parameters set to a path can be used as ~param
setopt auto_remove_slash # Remove trailing slash if next char is a word delim
setopt hash_list_all # Before completion, make sure entire path is hashed
setopt menu_complete # Tab cycles through completion possibilities

# Expansion and Globbing
setopt glob # Perform filename generation (i.e. the use of the * operator)
setopt extended_glob # Use additional glob operators
setopt mark_dirs # Directories resulting from globbing have trailing slashes
setopt no_nomatch # If a glob fails, use the literal string

# History
setopt hist_ignore_all_dups # Ignore all duplicates when writing history
setopt hist_ignore_space # Ignore commands that begin with spaces
setopt inc_append_history # Write commands to history file as soon as possible

# Input/Output
setopt clobber # Allows '>' to truncate files and '>>' to create files
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
setopt prompt_sp # Try to preserve lines that would be covered by the \r
setopt prompt_subst # Substitute in parameter/command/arithmetic expansions

# ZLE
setopt no_beep # The shell shouldn't beep on ZLE errors (most beeps)
setopt zle # Use ZLE. This is default, but I like to be explicit


# Interactive environment
#--------------------

[[ -a $(which subl) ]] && EDITOR=ex   || EDITOR=vim
[[ -a $(which subl) ]] && VISUAL=subl || VISUAL=vim
[[ -a $(which most) ]] && PAGER=most  || PAGER=less
export EDITOR VISUAL PAGER

HISTSIZE=2000
HISTFILE=${ZDOTDIR}/.history
SAVEHIST=$HISTSIZE
export HISTSIZE HISTFILE SAVEHIST


# Aliases
#--------------------

alias mv="nocorrect mv"
alias ln="nocorrect ln"
alias cp="nocorrect cp"

alias l="pwd && $(which ls) -lhF"
alias la="l -a"


# Keyboard
#--------------------

autoload -Uz zkbd
[[ ! -f ${ZDOTDIR}/zkbd/${TERM}-${HOST} ]] && zkbd
source ${ZDOTDIR}/zkbd/${TERM}-${HOST}

bindkey -e
[[ -n "${key[Home]}"       ]] && bindkey "${key[Home]}"   beginning-of-line
[[ -n "${key[End]}"        ]] && bindkey "${key[End]}"    end-of-line
[[ -n "${key[Insert]}"     ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}"     ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Up]}"         ]] && bindkey "${key[Up]}"     up-line-or-search
[[ -n "${key[Down]}"       ]] && bindkey "${key[Down]}"   down-line-or-search
[[ -n "${key[Left]}"       ]] && bindkey "${key[Left]}"   backward-char
[[ -n "${key[Right]}"      ]] && bindkey "${key[Right]}"  forward-char
[[ -n "${key[Ctrl-Left]}"  ]] && bindkey "${key[Ctrl-Left]}"  backward-word
[[ -n "${key[Ctrl-Right]}" ]] && bindkey "${key[Ctrl-Right]}" forward-word


# Prompt
#--------------------

# Set a default prompt to be used if the prompt library fails
PS1='%1~ %# '

# Initialize the prompt library and select the prompt
autoload -U promptinit && promptinit
prompt cbarrick


# Completion
#--------------------

autoload -U compinit && compinit


# ZLE
#--------------------

# Credit: Mikael Magnusson (Mikachu)
# Type '...' to get '../..'  etc
function rationalise-dot {
    local MATCH # keep the regex match from leaking to the environment
    if [[ $LBUFFER =~ '(^|/| |      |'$'\n''|\||;|&)\.\.$' ]]; then
      LBUFFER+=/
      zle self-insert
      zle self-insert
    else
      zle self-insert
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert


# Execute on startup
#--------------------

print "${USER} @ ${HOST}"
