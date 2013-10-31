export ZDOTDIR=${HOME}/.zsh.d

# Add local functions to fpath
typeset -U fpath
fpath=(${ZDOTDIR:-${HOME}}/.zlibs/functions ${fpath})

# Environmental variables
EDITOR=vim
VISUAL=vim
PAGER=less
LESS='-R -+X'
export EDITOR VISUAL PAGER LESS

# Shell Options. These are listed in the same order as chapter 16, section 2
# of the ZSH manual. See zshoptions(1) or online at
# http://zsh.sourceforge.net/Doc/Release/Options.html

# Changing Directories 16.2.1
setopt no_chase_links # Treat links as real directories

# Completion 16.2.2
setopt auto_list # List choices on ambiguous completion
setopt auto_name_dirs # Parameters set to a path can be used as ~param
setopt auto_remove_slash # Remove trailing slash if next char is a word delim
setopt hash_list_all # Before completion, make sure entire path is hashed
setopt menu_complete # Tab cycles through completion possibilities

# Expansion and Globbing 16.2.3
setopt glob # Perform filename generation (i.e. the use of the * operator)
setopt extended_glob # Use additional glob operators
setopt mark_dirs # Directories resulting from globbing have trailing slashes

# History 16.2.4
# See 20_History

# Input/Output 16.2.6
setopt clobber # Allows '>' to truncate files and '>>' to create files
setopt correct_all # Try to correct the spelling of all commands and arguments
setopt interactive_comments # Allow comments in interactive shells

# Job Control 16.2.7
setopt auto_continue # When suspended jobs are disowned, resume them in the bg
setopt auto_resume # single-word simple commands are candidates for resumption
setopt bg_nice # Run background jobs at lower priority
setopt check_jobs # Warn about background & suspended jobs on exit
setopt monitor # Enable job control. This is default.

# Prompting 16.2.8
# See 40_Prompt

# ZLE 16.2.12
setopt no_beep # The shell shouldn't beep on ZLE errors (most beeps)
setopt zle # Use ZLE. This is default, but I like to be explicit
setopt append_history
setopt bang_hist
setopt hist_ignore_dups
setopt hist_ignore_space

HISTSIZE=2000
HISTFILE=${ZDOTDIR:-${HOME}}/.history
SAVEHIST=$HISTSIZE
export HISTSIZE HISTFILE SAVEHIST
# On my Mac I use iTerm2 to emulate urxvt with the following exceptions
#     - I use ctrl+tab and shift+crtl+tab for other actions
#     - page up/down is swaped with shift+page up/down
#         - page up/down scroll the buffer
#         - shift+page up/down send page up/down key signals
#     - command+up/down also sends page up/down key signals
#     - home and end scroll to the start or end of the buffer
#     - command+left and command+right send home and end key signals
#     - function keys with modifiers are unbound
#     - F20 is unbound because my keyboard only goes through F19
#     - No insert key on my keyboard
# Also note my Mac doesn't have a Menu key but Menu and F16 send the same codes

autoload -Uz zkbd
[[ ! -f ${ZDOTDIR:-${HOME}}/.zlibs/zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && zkbd
source ${ZDOTDIR:-${HOME}}/.zlibs/zkbd/${TERM}-${VENDOR}-${OSTYPE}

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
# Prompt options
setopt prompt_cr # Print a \r before the prompt
setopt prompt_sp # Try to preserve lines that would be covered by the \r
setopt prompt_subst # Substitute in parameter/command/arithmetic expansions

# Set a default prompt to be used if the prompt library fails
#PS1='%1~ %# '

# Initialize the prompt library and select the prompt
autoload -Uz promptinit
promptinit
prompt cbarrick

# See the prompt_cbarrick_setup function for the implementation of the prompt.
# It should be noted that the cbarrick prompt autoloads vcs_info so there is no
# need to do that here.
# TODO: Document the prompt options
# A simple function to activate a python virtual environment
function pyenv {
    ${HOME}/Library/Python/${1}/bin/activate
}
