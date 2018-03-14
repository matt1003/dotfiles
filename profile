# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
