# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod1

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:DejaVu Sans Mono Nerd Font, Bold 10

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+space exec terminator --role=no_floating
for_window [window_role=no_floating] floating disable

# kill focused window
bindsym $mod+e kill

# start dmenu (a program launcher)
bindsym $mod+semicolon exec "rofi -lines 12 -padding 18 -width 60 -location 0 -show run -sidebar-mode -columns 3 -font 'Noto Sans 8'"
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+i split h

# split in vertical orientation
bindsym $mod+u split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+t layout tabbed
bindsym $mod+d layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+f floating toggle

# change focus between tiling / floating windows
#bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# switch to workspace
bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+6 workspace number 6
bindsym $mod+7 workspace number 7
bindsym $mod+8 workspace number 8
bindsym $mod+9 workspace number 9
bindsym $mod+0 workspace number 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9
bindsym $mod+Shift+0 move container to workspace number 10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec rofi-power

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

###############################################################################
# bindings
###############################################################################

# move current workplace
bindsym $mod+Control+h move workspace to output left
bindsym $mod+Control+l move workspace to output right

# alternatively use the cursor keys
bindsym $mod+Control+Left move workspace to output left
bindsym $mod+Control+Right move workspace to output right

# lock screen
bindsym Mod4+l exec --no-startup-id i3-pixelate

# audio control
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl -- set-sink-volume 1 +5%
bindsym XF86AudioLowerVolume exec --no-startup-id pactl -- set-sink-volume 1 -5%
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 1 toggle

# sreen brightness control
bindsym XF86MonBrightnessUp exec --no-startup-id xbacklight -inc 10
bindsym XF86MonBrightnessDown exec --no-startup-id xbacklight -dec 10

# touch pad control
bindsym XF86Display exec --no-startup-id touchpad

# print screen
bindsym --release Print exec --no-startup-id screenshot
bindsym --release shift+Print exec --no-startup-id screenshot -s

# reload display configuration
bindsym $mod+m exec --no-startup-id "display-reload.sh"

# alt tab to cycle through tabs and splits
bindsym $mod+Tab --no-startup-id exec i3-swap

###############################################################################
# gruv box color codes
###############################################################################

# set primary gruvbox colorscheme colors
set $bg #282828
set $fg #a89984
set $red #cc241d
set $green #98971a
set $yellow #d79921
set $blue #458588
set $purple #b16286
set $aqua #689d68
set $gray #665c54
set $darkgray #1d2021

# window color:         border | backgr | text | indicator | child_border
client.focused          $fg     $fg       $bg    $purple     $fg
client.focused_inactive $fg     $fg       $bg    $purple     $fg
client.unfocused        $bg     $bg       $fg    $purple     $darkgray
client.urgent           $red    $red      $bg    $purple     $red

###############################################################################
# status bar
###############################################################################

# main status bar
bar {
        colors {
            background $bg
            statusline $red
            separator  $gray
            # workspace colors:  border | backgr | text
            focused_workspace    $fg      $fg      $bg
            active_workspace     $bg      $bg      $fg
            inactive_workspace   $bg      $bg      $fg
            urgent_workspace     $red     $red     $bg
        }
        status_command exec i3-status 2> /tmp/i3-status.log
        font pango:DejaVuSansMono Nerd Font 10
        #output primary
        tray_output primary
        # define mouse button actions
        bindsym button3 exec --no-startup-id display-reload
        bindsym button2 exec --no-startup-id amixer -q -D pulse set Master 1+ toggle
        bindsym button4 exec --no-startup-id amixer -q set Master 5%+ unmute
        bindsym button5 exec --no-startup-id amixer -q set Master 5%- unmute
}

###############################################################################
# other settings
###############################################################################

# disable window title bars
new_window 1pixel

# only show borders for splits
hide_edge_borders smart

# set the border width
for_window [class="^.*"] border pixel 2

# center align window titles
#title_align center

# this is needed otherwise the cursor will jump to the center of the screen when
# clicking on firefox tabs; it appears that the rename workspace command in i3-
# icons is causing this to happen
mouse_warping none
focus_follows_mouse no

# note : firefox will toggle the menu bar when alt is presses, this can be disabled
# using by going to the link: about:config?filter=ui.key.menuAccessKeyFocuses

###############################################################################
# start up
###############################################################################

# enable num lock
exec --no-startup-id /usr/bin/numlockx on

exec --no-startup-id amixer -q set Master 20% unmute

# enable transparent windows
#exec --no-startup-id compton --config ~/.compton.conf

# set background image
exec --no-startup-id feh --bg-fill ~/.background

# manage network interfaces
exec --no-startup-id nm-applet
#exec --no-startup-id blueman-applet
#exec --no-startup-id system-config-printer-applet

# enable workspace icons
exec_always --no-startup-id i3-icons 2> /tmp/i3-icons.log

# set the display layout
exec --no-startup-id display-reload
#exec --no-startup-id i3-msg '[workspace=1] move workspace to output primary'
#exec --no-startup-id i3-msg '[workspace=2] move workspace to output DP-5.1'
#exec --no-startup-id i3-msg '[workspace=3] move workspace to output DP-5.2'

#workspace 1 output primary
#workspace 2 output DP-5.1
#workspace 3 output DP-5.2

# startup application
#exec --no-startup-id i3-msg 'workspace number 1; exec /usr/bin/firefox'
#exec --no-startup-id i3-msg 'workspace number 3; exec /usr/bin/terminator.wrapper'

