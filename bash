
setxkbmap -option caps:escape

HISTSIZE=5000
HISTFILESIZE=50000

alias s0='minicom -D /dev/ttyS0   -C /home/matthewbr/minicom-s0'
alias s1='minicom -D /dev/ttyS1   -C /home/matthewbr/minicom-s1'
alias s2='minicom -D /dev/ttyS2   -C /home/matthewbr/minicom-s2'
alias u0='minicom -D /dev/ttyUSB0 -C /home/matthewbr/minicom-u0'
alias u1='minicom -D /dev/ttyUSB1 -C /home/matthewbr/minicom-u1'
alias u2='minicom -D /dev/ttyUSB2 -C /home/matthewbr/minicom-u2'

alias gad='git add'
alias gbi='git bisect'
alias gbr='git branch'
alias gco='git checkout'
alias gcl='git clone'
alias gcm='git commit'
alias gcp='git cherry-pick'
alias gdi='git diff'
alias gfe='git fetch'
alias ggr='git grep'
alias gin='git init'
alias glo='git log'
alias gme='git merge'
alias gmv='git mv'
alias grb='git rebase'
alias grm='git rm'
alias gpl='git pull'
alias gph='git push'
alias grs='git reset'
alias gse='git send-email'
alias gsu='git setup'
alias gsh='git show'
alias gst='git status'
alias gta='git tag'

alias gbrd='confirm && git branch -D'
alias grss='confirm && git reset --soft'
alias grsh='confirm && git reset --hard'

alias gdid='git difftool -t diffuse'
alias gdik='git difftool -t kdiff3'
alias gdim='git difftool -t meld'
alias gdiv='git difftool -t vimdiff'

alias gmed='git mergetool -t diffuse'
alias gmek='git mergetool -t kdiff3'
alias gmem='git mergetool -t meld'

alias gitk='gitk --all &'

alias gitg='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
# see http://stackoverflow.com/questions/1057564/pretty-git-branch-graphs

alias ll='ls --group-directories-first --time-style=long-iso -hl'
alias lla='ls --group-directories-first --time-style=long-iso -hlA'

alias his="history | sed 's/^ *[0-9]* *//' | grep"

alias rm='rm -i'

alias tra='trash'

alias pdu='powerbox 192.168.0.3'

alias gvim='gvim -geometry 500x500'

alias update='sudo apt update && sudo apt upgrade && sudo apt auto-remove && echo -e "\e[34m** DONE **\e[0m"'

cdback() { cd $(echo $PWD | sed -r "s/($1\w*\/).*/\1/") ; }

alias cdb=cdback

cpwdir() { mkdir -p -- "$(dirname -- "$2")" && cp -- "$1" "$2" ; }

alias cpd=cpwdir

alias gvimr='gvim --remote'

alias reboot='confirm && confirm "Are you *REALLY* sure you want to reboot *THIS* workstation?" && reboot'

alias tmux=tmux-next

alias tmux-session="tmux-next new-session -A -s" 

if [[ $USER =~ matthew.* ]]; then
  export uname="\e[01;32m\u\e[m"
else
  export uname="\e[01;31m\u\e[m"
fi

if [ "$SSH_CONNECTION" ]; then
  export hname="\e[01;31m\h\e[m"
else
  export hname="\e[01;32m@\h\e[m"
fi

export cpath="\e[01;34m\w\e[m"

export PS1="$uname$hname:$cpath\$ "

