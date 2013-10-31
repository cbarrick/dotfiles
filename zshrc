#!/bin/zsh


# Shell Options. See zshoptions(1) or online at
# http://zsh.sourceforge.net/Doc/Release/Options.html
#--------------------

# Changing Directories
setopt no_chase_links # Treat links as real directories

# Completion
setopt auto_list # List choices on ambiguous completion
setopt auto_name_dirs # Parameters set to a path can be used as ~param
setopt auto_remove_slash # Remove trailing slash if next char is a word delim
setopt hash_list_all # Before completion, make sure entire path is hashed
setopt menu_complete # Tab cycles through completion possibilities

# Expansion and Globbing
setopt glob # Perform filename generation (i.e. the use of the * operator)
#setopt extended_glob # Use additional glob operators
setopt mark_dirs # Directories resulting from globbing have trailing slashes

# Input/Output
setopt clobber # Allows '>' to truncate files and '>>' to create files
setopt correct_all # Try to correct the spelling of all commands and arguments
setopt interactive_comments # Allow comments in interactive shells

# Job Control
setopt auto_continue # When suspended jobs are disowned, resume them in the bg
setopt auto_resume # single-word simple commands are candidates for resumption
setopt bg_nice # Run background jobs at lower priority
setopt check_jobs # Warn about background & suspended jobs on exit
setopt monitor # Enable job control. This is default.

# ZLE
setopt no_beep # The shell shouldn't beep on ZLE errors (most beeps)
setopt zle # Use ZLE. This is default, but I like to be explicit

# History
setopt append_history
setopt bang_hist
setopt hist_ignore_dups
setopt hist_ignore_space

# Prompt
setopt prompt_cr # Print a \r before the prompt
setopt prompt_sp # Try to preserve lines that would be covered by the \r
setopt prompt_subst # Substitute in parameter/command/arithmetic expansions

# Interactive environment
#--------------------

# Add local functions to fpath
typeset -U fpath
fpath=(${ZDOTDIR:-${HOME}}/zlibs/functions ${fpath})

# Defaults
EDITOR=vim
VISUAL=vim
PAGER=less
LESS='-R -+X'
export EDITOR VISUAL PAGER LESS

# History
HISTSIZE=2000
HISTFILE=${ZDOTDIR:-${HOME}}/.history
SAVEHIST=$HISTSIZE
export HISTSIZE HISTFILE SAVEHIST


# Keyboard
#--------------------

autoload -Uz zkbd
[[ ! -f ${ZDOTDIR:-${HOME}}/zlibs/zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && zkbd
source ${ZDOTDIR:-${HOME}}/zlibs/zkbd/${TERM}-${VENDOR}-${OSTYPE}

bindkey -e
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-search
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-search
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[Ctrl-Left]}"  ]] && bindkey "${key[Ctrl-Left]}"  backward-word
[[ -n "${key[Ctrl-Right]}" ]] && bindkey "${key[Ctrl-Right]}" forward-word

# Prompt
#--------------------


# Set a default prompt to be used if the prompt library fails
PS1='%1~ %# '

# Initialize the prompt library and select the prompt
autoload -Uz promptinit
promptinit
prompt cbarrick
