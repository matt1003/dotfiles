
# use ctrl+a as prefix
set -g prefix C-z

# reload tmux config
bind-key r source-file ~/.tmux.conf

# start window numbering from 1
set -g base-index 1

# renumber windows sequentially after closing
set -g renumber-windows on

# enable mouse support
set -g mouse on

# enable true color support
set -g default-terminal "xterm-256color"
set-option -ga terminal-overrides ",xterm-256color:Tc"

# integration with vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind-key -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"

# custom key bindings
unbind n
bind-key n new-window
bind-key m confirm kill-window
bind-key M confirm kill-session
bind-key . next-window
bind-key , previous-window
bind-key \ split-window -h
bind-key - split-window -v

# load tmux line config
set -g status-justify "left"
set -g status "on"
set -g status-attr "none"
set -g message-command-bg "#504945"
set -g status-left-length "100"
set -g pane-active-border-fg "#928374"
set -g status-bg "#3c3836"
set -g message-command-fg "#a89984"
set -g pane-border-fg "#504945"
set -g message-bg "#504945"
set -g status-left-attr "none"
set -g status-right-attr "none"
set -g status-right-length "100"
set -g message-fg "#a89984"
setw -g window-status-fg "#a89984"
setw -g window-status-attr "bold"
setw -g window-status-activity-bg "#3c3836"
setw -g window-status-activity-attr "none"
setw -g window-status-activity-fg "#928374"
setw -g window-status-separator ""
setw -g window-status-bg "#3c3836"
set -g status-left "#[fg=#1d2021,bg=#928374] #S #[fg=#928374,bg=#3c3836,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#504945,bg=#3c3836,nobold,nounderscore,noitalics]#[fg=#a89984,bg=#504945] %Y-%m-%d  %H:%M #[fg=#928374,bg=#504945,nobold,nounderscore,noitalics]#[fg=#1d2021,bg=#928374] #h "
setw -g window-status-format "#[fg=#a89984,bg=#3c3836,bold] #I #[fg=#a89984,bg=#3c3836,bold] #W "
setw -g window-status-current-format "#[fg=#3c3836,bg=#504945,nobold,nounderscore,noitalics]#[fg=#a89984,bg=#504945] #I #[fg=#a89984,bg=#504945] #W #[fg=#504945,bg=#3c3836,nobold,nounderscore,noitalics]"

