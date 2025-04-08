#
# ~/.bashrc: executed by bash for non-login shells.
#

# source original bashrc
if [ -f ~/.bashrc.orig ]; then
    . ~/.bashrc.orig
fi

# unlimited bash history size
HISTSIZE=-1
HISTFILESIZE=-1

# immediately write to global bash history
export PROMPT_COMMAND="history -a ~/.bash_history.global; $PROMPT_COMMAND"

# map ctrl-r to run hstr using the global bash history
if [[ $- =~ .*i.* ]]; then
  bind -x '"\C-r": "HISTFILE=~/.bash_history.global hstr -- $READLINE_LINE; READLINE_LINE="'
fi

# force hstr to use a color prompt
export HH_CONFIG=hicolor

if [ "$color_prompt" = yes ]; then
  if [ $SESSION_TYPE = "local" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  fi
fi

# source local bashrc
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

