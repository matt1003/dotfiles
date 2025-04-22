
###############################################################################
# instant prompt
###############################################################################

if [ -r "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]; then
  source "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###############################################################################
# installation
###############################################################################

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "\e[1minstalling oh-my-zsh...\e[0m"
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi

# install power-level-10k
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo -e "\e[1minstalling power-level-10k...\e[0m"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi


###############################################################################
# zsh configuration
###############################################################################

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

###############################################################################
# oh-my-zsh configuration
###############################################################################

# path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# set the oh-my-zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# use hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# enable command auto-correction
ENABLE_CORRECTION="true"

# disable username and host from window name
ZSH_THEME_TERM_TITLE_IDLE="zsh"

# set the oh-my-zsh plugins
plugins=(git)

###############################################################################
# powerlevel10k configuration
###############################################################################

# load the color scheme
if [ -r "$HOME/bin/color-scheme" ]; then
  source "$HOME/bin/color-scheme"
fi

# load the powerlevel10k configuration
if [ -r "$HOME/.p10k.zsh" ]; then
  source "$HOME/.p10k.zsh"
fi

###############################################################################
# startup
###############################################################################

# fire up oh-my-zsh
source $ZSH/oh-my-zsh.sh

# override the following aliases
alias ll='ls --group-directories-first --time-style=long-iso -hl'
alias la='ls --group-directories-first --time-style=long-iso -hlA'
alias lt='ls --group-directories-first --time-style=long-iso -hlAt'

# load work settings
[ -r "$HOME/work/.zshrc" ] && source "$HOME/work/.zshrc"

