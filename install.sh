#!/bin/bash

script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

#
# define dotfiles
#
declare -A dotfiles=(
  [bash_aliases]=.bash_aliases
  [bash_profile]=.bash_profile
  [bashrc]=.bashrc
  [minirc]=.minirc.dfl
  [profile]=.profile 
  [terminator.conf]=.config/terminator/config
  [tmux.conf]=.tmux.conf
  [vimrc]=.vimrc
)

#
# define packages
#
declare packages=(
  cscope 
  ctags
  minicom
  terminator
  tmux-next 
  trash-cli 
  vim
  xcape
)

#
# define fonts
#
fonts=https://github.com/powerline/fonts.git 

#
# install packages and fonts
#
if [ ! -z $1 ] && [ $1 == "full" ]; then

  echo -e "\e[34madding apt repositories...\e[0m"
  # required for terminator 1.91 ...
  sudo add-apt-repository ppa:gnome-terminator/nightly-gtk3
  # required for tmux 2.3 ...
  sudo add-apt-repository -yu ppa:pi-rho/dev
  # required for vim 8.0 ...
  sudo add-apt-repository ppa:jonathonf/vim

  echo -e "\e[34minstalling apt packages...\e[0m"
  sudo apt update
  sudo apt install ${packages[*]}

  echo -e "\e[34minstalling powerline fonts...\e[0m"
  git clone $fonts /tmp/powerlinefonts
  /tmp/powerlinefonts/install.sh
  rm -rf /tmp/powerlinefonts

fi

#
# install dotfiles
#
echo -e "\e[34minstalling configuration files...\e[0m"
for file in "${!dotfiles[@]}"; do
  path="$HOME/${dotfiles[$file]}"
  if [ -f $path ] && [ ! -h $path ]; then
    mv $path $path.orig
  fi
  ln -sfv $scriptpath/$file $path
done

echo -e "\e[34m * COMPLETE * \e[0m"

