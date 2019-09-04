#!/bin/bash
set -euo pipefail

if [ -z ${1+x} ]; then
  echo -e "\e[31merror: must specify arg: cli/gui/dot/gnome/bin/font/git/full"
  exit 1
fi

script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

#
# define cli applications
#
declare cli_apps=(
  #cscope
  #ctags
  git
  #hh
  minicom
  #neovim
  #ranger
  shellcheck
  silversearcher-ag
  #tmux-next
  trash-cli
  tree
  vim
  #xcape
  #xclip
  #xsel
  zsh
)
declare cli_ppas=(
  #ppa:git-core/ppa # required for latest git
  #ppa:jonathonf/vim # required for vim 8.0
  #ppa:neovim-ppa/unstable # required for neovim
  #ppa:pi-rho/dev # required for tmux 2.3
  #ppa:ultradvorka/ppa # required for hstr
)

#
# define gui applications
#
declare gui_apps=(
  firefox
  gedit
  git-gui
  gitk
  #gnome-tweak-tool
  meld
  pinta
  speedcrunch
  terminator
  wireshark

  i3
  rofi
  xautolock
  compton
  acpi
  scrot
  numlockx
)
declare gui_ppas=(
  #ppa:fkrull/speedcrunch-daily # latest version of speedcrunch
  #ppa:gnome-terminator/nightly-gtk3 # required for terminator 1.91
  #ppa:wireshark-dev/stable # required for latest wireshark
)

#
# define dotfiles
#
declare -A dotfiles=(
  #[bash_aliases]=.bash_aliases
  #[bash_profile]=.bash_profile
  #[bashrc]=.bashrc
  [compton.conf]=.compton.conf
  [dunstrc]=.config/dunst/dunstrc
  [gitignore]=.gitignore
  [i3]=.config/i3/config
  #[inputrc]=.inputrc
  [minimacros]=.macros
  [minirc]=.minirc.dfl
  #[nvimrc]=.config/nvim/init.vim
  #[profile]=.profile
  [terminator.conf]=.config/terminator/config
  [tmux.conf]=.tmux.conf
  [vimrc]=.vimrc
  [zshrc]=.zshrc
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
git_difftool=vimdiff
git_ignorefile=$HOME/.gitignore

#
# install cli apps
#
if [ $1 == "cli" ] || [ $1 == "full" ]; then
  echo -e "\e[34madding apt repositories...\e[0m"
  for ppa in "${cli_ppas[@]}"; do
    echo -n "adding $ppa ... "
    if grep -q "^deb .*${ppa#ppa:}" /etc/apt/sources.list.d/*; then
      echo "(already added)"
    else
      echo ""; sudo add-apt-repository -y $ppa
    fi
  done
  echo -e "\e[34minstalling apt cli apps...\e[0m"
  sudo apt-get update && sudo apt-get install -y ${cli_apps[*]}
fi

#
# install gui apps
#
if [ $1 == "gui" ] || [ $1 == "full" ]; then
  echo -e "\e[34madding apt repositories...\e[0m"
  for ppa in "${gui_ppas[@]}"; do
    echo -n "adding $ppa ... "
    if grep -q "^deb .*${ppa#ppa:}" /etc/apt/sources.list.d/*; then
      echo "(already added)"
    else
      echo ""; sudo add-apt-repository -y $ppa
    fi
  done
  echo -e "\e[34minstalling apt gui apps...\e[0m"
  sudo apt-get update && sudo apt-get install -y ${gui_apps[*]}
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
  for lau in "${gnome_launchers[@]}"; do
    cat $scriptpath/$lau | sed "s/@user@/$USER/g" | tee $HOME/.local/share/applications/$lau
    chmod 775 $HOME/.local/share/applications/$lau
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
# configure git settings
#
if [ $1 == "git" ] || [ $1 == "full" ]; then
  # git directory
  cd $scriptpath
  # local settings
  echo -e "\e[34mconfiguring git local settings...\e[0m"
  git config user.name "$git_name"
  echo "name: $git_name"
  git config user.email "$git_email"
  echo "email: $git_email"
  # global settings
  echo -e "\e[34mconfiguring git global settings...\e[0m"
  git config --global core.editor "$git_editor"
  echo "editor: $git_editor"
  git config --global diff.tool "$git_difftool"
  echo "difftool: $git_difftool"
  git config --global merge.tool "$git_difftool"
  echo "mergetool: $git_difftool"
  git config --global core.excludesfile "$git_ignorefile"
  echo "ignorefile: $git_ignorefile"
  # original directory
  cd -
fi

#
# other stuff
#
if [ $1 == "full" ]; then
  echo -e "\e[34mconfiguring other settings...\e[0m"
  # prevent gnome from stomping on xkb settings
  gsettings set org.gnome.settings-daemon.plugins.keyboard active false
fi

echo -e "\e[34m * COMPLETE * \e[0m"

#
# TODO
# - edit /etc/sudoers so that password is not required for sudo
# - edit /etc/group so that username is added to minicom and wireshark
# - edit /etc/default/grub so that there is no splash screen during boot
#
# sort out what python modules are needed ...
# sudo apt-get install pip
# sudo apt-get install python-pip
# pip install --upgrade pip
# pip install config
# pip install jenkins
# pip install jenkinsapi
# pip install BeautifulSoup
# pip install vim-vint
# pip install vim-vint
# pip install ansicolor
# pip uninstall ansicolor
# pip install 'ansicolor==0.2.4'
# sudo apt-get install pylint
