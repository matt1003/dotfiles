###############################################################################
# zsh configuration
###############################################################################

### preferred editor ###

 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

### aliases ###

alias vi='/usr/local/bin/nvim'
alias nvim='echo use vi!'

alias u0='minicom -D /dev/ttyUSB0 -C ~/minicom-u0'
alias u1='minicom -D /dev/ttyUSB1 -C ~/minicom-u1'
alias u2='minicom -D /dev/ttyUSB2 -C ~/minicom-u2'

### commands ###

gitk() { command gitk --all "$@" & disown }

goa () { /usr/local/bin/nvim $(git status --short --no-renames --untracked-files=all | awk -F ' ' '{print $2}') ; }

viag() { /usr/local/bin/nvim $(ag -l "$@") }

### search local history ###

# TODO: Does this actually work?
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
# oh-my-zsh configuration
###############################################################################

# path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# set the oh-my-zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# use hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# enable command auto-correction
ENABLE_CORRECTION="true"

# display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# disable username and host from window name
ZSH_THEME_TERM_TITLE_IDLE="zsh"

# set the oh-my-zsh plugins
plugins=(git)

###############################################################################
# power-level-10k configuration
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

# version control colors
POWERLEVEL9K_VCS_CLEAN_BACKGROUND="clear"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="10" # green
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="clear"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="11" # yellow
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="clear"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="11" # yellow

# directory colors
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="12" # blue
POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_FOREGROUND="12" # blue
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="12" # blue
POWERLEVEL9K_DIR_ETC_BACKGROUND="clear"
POWERLEVEL9K_DIR_ETC_FOREGROUND="12" # blue
POWERLEVEL9K_DIR_WRITABLE_BACKGROUND="clear"
POWERLEVEL9K_DIR_WRITABLE_FOREGROUND="9" # red

# other colors
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="clear"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="8" # gray
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="9" # red
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="11" # yellow

# display the lock icon when files cannot be edited
POWERLEVEL9K_DIR_SHOW_WRITABLE=true

# only display the status when there has been an error
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_HIDE_SIGNAME=false

# only print execution time if it exceeds this threshold
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

###############################################################################
# startup
###############################################################################

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi

# install power-level-10k
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi

# fire up oh-my-zsh
source $ZSH/oh-my-zsh.sh

# override the following aliases
alias ll='ls --group-directories-first --time-style=long-iso -hl'
alias la='ls --group-directories-first --time-style=long-iso -hlA'
alias lt='ls --group-directories-first --time-style=long-iso -hlAt'
