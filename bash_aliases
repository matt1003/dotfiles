
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

gitkall () { gitk --all $@ & disown %1 ; }

alias gitk=gitkall

alias gitg='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
# see http://stackoverflow.com/questions/1057564/pretty-git-branch-graphs

alias goa='vim $(git diff --name-only | tr "\n" " ")'

alias ll='ls --group-directories-first --time-style=long-iso -hl'
alias la='ls --group-directories-first --time-style=long-iso -hlA'

alias his="history | sed 's/^ *[0-9]* *//' | grep"

alias rm='rm -i'

alias tra='trash'

alias gvim='gvim -geometry 500x500'

alias update='sudo apt update && sudo apt upgrade && sudo apt auto-remove && echo -e "\e[34m** DONE **\e[0m"'

cdback() { cd $(echo $PWD | sed -r "s/($1\w*\/).*/\1/") ; }

alias cdb=cdback

cpwdir() { mkdir -p -- "$(dirname -- "$2")" && cp -- "$1" "$2" ; }

alias cpd=cpwdir

alias gvimr='gvim --remote'

alias reboot='confirm && confirm "Are you *REALLY* sure you want to reboot $HOSTNAME?" && reboot'

alias tmux-session='tmux new-session -A -s'

alias tmux-dev='terminator -l tmux && exit 0'

alias build='buildwrap'

