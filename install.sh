#!/bin/bash
set -e

if [ -z $1 ]; then
  echo -e "\e[31merror: must specify arg: cli/gui/dot/gnome/bin/font/git/full"
  exit 1
fi

script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

#
# define cli applications
#
declare cli_apps=(
  cscope
  ctags
  git
  minicom
  numlockx
  silversearcher-ag
  tmux-next
  trash-cli
  tree
  vim
  xcape
  xclip
  xsel
)

#
# define gui applications
#
declare gui_apps=(
  firefox
  gedit
  git-git
  gnome-tweak-tool
  meld
  pinta
  speedcrunch
  terminator
  wireshark
)

#
# define dotfiles
#
declare -A dotfiles=(
  [bash_aliases]=.bash_aliases
  [bash_profile]=.bash_profile
  [bashrc]=.bashrc
  [gitignore]=.gitignore
  [inputrc]=.inputrc
  [minirc]=.minirc.dfl
  [profile]=.profile
  [terminator.conf]=.config/terminator/config
  [tmux.conf]=.tmux.conf
  [vimrc]=.vimrc
)

#
# define launchers
#
declare gnome_launchers=(
  tmux.desktop
)

#
# define fonts
#
fonts=https://github.com/powerline/fonts.git

#
# define get info
#
git_name=matt1003
git_email=matt1003@gmail.com
git_editor=vim

#
# install cli apps
#
if [ $1 == "cli" ] || [ $1 == "full" ]; then
  echo -e "\e[34madding apt repositories...\e[0m"
  # required for tmux 2.3 ...
  sudo add-apt-repository -y ppa:pi-rho/dev
  # required for vim 8.0 ...
  sudo add-apt-repository -y ppa:jonathonf/vim
  echo -e "\e[34minstalling apt cli apps...\e[0m"
  sudo apt update && sudo apt install ${cli_apps[*]}
  # prevent gnome from stomping on xkb settings
  gsettings set org.gnome.settings-daemon.plugins.keyboard active false
fi

#
# install gui apps
#
if [ $1 == "gui" ] || [ $1 == "full" ]; then
  echo -e "\e[34madding apt repositories...\e[0m"
  # required for terminator 1.91 ...
  sudo add-apt-repository -y ppa:gnome-terminator/nightly-gtk3
  echo -e "\e[34minstalling apt gui apps...\e[0m"
  sudo apt update && sudo apt install ${gui_apps[*]}
fi

#
# install dotfiles
#
if [ $1 == "dot" ] || [ $1 == "full" ]; then
  echo -e "\e[34minstalling config files...\e[0m"
  for file in "${!dotfiles[@]}"; do
    path="$HOME/${dotfiles[$file]}"
    if [ ! -d $(dirname $path) ]; then
      mkdir -p $(dirname $path)
    elif [ -f $path ] && [ ! -h $path ]; then
      if [ -f $path.orig ]; then
        echo -e "\e[31merror: $path.orig already exists\e[0m"
        exit 1
      fi
      mv -v $path $path.orig
    fi
    ln -sfv $scriptpath/$file $path
  done
fi

#
# install gnome launchers
#
if [ $1 == "gnome" ] || [ $1 == "full" ]; then
  echo -e "\e[34minstalling gnome launchers...\e[0m"
  for launcher in "${gnome_launchers[@]}"; do
    cat $launcher | sed "s/@user@/$USER/g" | tee $HOME/.local/share/applications/$launcher
    chmod 775 $HOME/.local/share/applications/$launcher
  done
fi

#
# install binaries
#
if [ $1 == "bin" ] || [ $1 == "full" ]; then
  echo -e "\e[34minstalling bin files...\e[0m"
  [ -h $HOME/bin ] && unlink $HOME/bin
  [ -d $HOME/bin ] && mv -v $HOME/bin $HOME/bin.orig
  ln -sv $scriptpath/bin $HOME/bin
fi

#
# install fonts
#
if [ $1 == "font" ] || [ $1 == "full" ]; then
  echo -e "\e[34minstalling powerline fonts...\e[0m"
  git clone $fonts /tmp/powerlinefonts
  /tmp/powerlinefonts/install.sh
  rm -rf /tmp/powerlinefonts
fi

#
# configure local git
#
if [ $1 == "git" ] || [ $1 == "full" ]; then
  echo -e "\e[34mconfiguring local git...\e[0m"
  git config user.name "$git_name"
  echo "name: $git_name"
  git config user.email "$git_email"
  echo "email: $git_email"
  git config core.editor "$git_editor"
  echo "editor: $git_editor"
fi

echo -e "\e[34m * COMPLETE * \e[0m"

#
# TODO
# - edit /etc/sudoers so that password is not required for sudo
# - edit /etc/group so that username is added to minicom and wireshark
# - edit /etc/default/grub so that there is no splash screen during boot
# - git config --global core.excludesfile '~/.gitignore'
#

