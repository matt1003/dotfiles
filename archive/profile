#
# ~/.profile: executed by the command interpreter for login shells.
#

# detect remote connections
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  export SESSION_TYPE=remote
else
  export SESSION_TYPE=local
fi

# enable num lock on login
if [ $SESSION_TYPE = "local" ]; then
  numlockx on
fi

# remap caps-lock to ctrl+esc
if [ -f "$HOME/.caps_to_ctrl_esc" ]; then
  if [ -n "$DISPLAY" ]; then
    setxkbmap -option caps:ctrl_modifier
    xcape -e Caps_Lock=Escape
  fi
fi

# clean out old build results
if [ -d "$HOME/.tmux" ]; then
  if [ -x "$HOME/bin/buildwrap" ]; then
    $HOME/bin/buildwrap clear
  fi
fi

# source the original profile
if [ -f "$HOME/.profile.orig" ]; then
  . "$HOME/.profile.orig"
fi

