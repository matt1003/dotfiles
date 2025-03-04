# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

###############################################################################
# config for power level 9k
###############################################################################

POWERLEVEL9K_MODE='nerdfont-complete'

# cli input on new line
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# disable separators
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''

# change the start of line symbols so that the first line is always blank
# (as the first line is used for the return status of the previous command)
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{12}\u256D\u2500%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{12}\u2570\uf460%f "

# define what is to be displayed on the left prompt
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status command_execution_time newline dir_joined vcs_joined)

# define what is to be displayed on the right prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# print colors
#i=0
#for COLOR in {0..255}
#do
#    for STYLE in "38;5"
#    do
#        TAG="\033[${STYLE};${COLOR}m"
#        STR="${STYLE};${COLOR}"
#        echo -ne "${TAG}${i}..${STR}${NONE}  "
#        let i++
#    done
#    echo
#done

grey="8"
red="9"
green="10"
yellow="11"
blue="12"

# version control colors
POWERLEVEL9K_VCS_CLEAN_BACKGROUND="clear"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$green
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="clear"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$yellow
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="clear"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$yellow

# directory colors
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=$blue
POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_FOREGROUND=$blue
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$blue
POWERLEVEL9K_DIR_ETC_BACKGROUND="clear"
POWERLEVEL9K_DIR_ETC_FOREGROUND=$blue
POWERLEVEL9K_DIR_WRITABLE_BACKGROUND="clear"
POWERLEVEL9K_DIR_WRITABLE_FOREGROUND="red"

# other colors
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='clear'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$grey
POWERLEVEL9K_STATUS_ERROR_BACKGROUND=$red
POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$yellow

# display the lock icon when files cannot be edited
POWERLEVEL9K_DIR_SHOW_WRITABLE=true

# only display the status when there has been an error
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_HIDE_SIGNAME=false

# only print execution time if it exceeds this threshold
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

#POWERLEVEL9K_STATUS_OK_BACKGROUND="clear"
#POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
#POWERLEVEL9K_TIME_BACKGROUND="clear"
#POWERLEVEL9K_TIME_FOREGROUND="cyan"
#POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='clear'
#POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='green'# Setting this variable when ZSH_THEME=random
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
#POWERLEVEL9K_SHORTEN_DELIMITER=""
#POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

###############################################################################

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

###############################################################################
# local history
###############################################################################

# up/down key search local history only
# todo this doesn't seem to be working
#bindkey "${key[Up]}" up-line-or-local-history
#bindkey "${key[Down]}" down-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history

down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

###############################################################################
# aliases
###############################################################################

alias ll='ls --group-directories-first --time-style=long-iso -hl'
alias la='ls --group-directories-first --time-style=long-iso -hlA'
alias lt='ls --group-directories-first --time-style=long-iso -hlAt'

alias u0='minicom -D /dev/ttyUSB0 -C ~/minicom-u0'
alias u1='minicom -D /dev/ttyUSB1 -C ~/minicom-u1'
alias u2='minicom -D /dev/ttyUSB2 -C ~/minicom-u2'

gitkall () { gitk --all $@ & disown %1 ; }
alias gitk=gitkall

gitopenall () { nvim $(git diff --name-only | awk "{print \"$(git rev-parse --show-toplevel)/\"\$1}") ; }
gitopenall2 () { nvim $(git status --short --no-renames --untracked-files=all | awk -F ' ' '{print $2}') ; }
alias goa=gitopenall2

function nag() {
  nvim $(aag -l "$@")
}

alias svim='vim -u ~/.SpaceVim/vimrc --cmd "set rtp^=~/.SpaceVim"'

alias findtime='find -printf "%Tc %p\n"'

###############################################################################
# other
###############################################################################

# disable username and host from window name
ZSH_THEME_TERM_TITLE_IDLE="zsh"

cp ~/.zsh_history ~/.zsh_history_backup/.zsh_history~$(date '+%Y-%m-%d~%H:%M:%S')
