#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


# apt misc setup
sudo apt update
sudo apt full-upgrade
sudo apt install -y software-properties-common


# misc installs
sudo apt install -y \
    git \
    htop \
    mtr \
    jq


# installs rq
sudo curl \
     https://s3-eu-west-1.amazonaws.com/record-query/record-query/x86_64-unknown-linux-gnu/rq \
     -o /usr/local/bin/rq \
    && sudo chmod +x /usr/local/bin/rq


# sets this repository locally, will use it later in this very script
git clone https://github.com/betafcc/eos-bootstrapping.git ~/.betafcc


# # install termite
# curl -s https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | sh
# rm -rf termite vte-ng
# # configs termite
# mkdir -p ~/.config/termite
# cp ~/.betafcc/dotfiles/.config/termite/config ~/.config/termite/


# # install terminator
# sudo add-apt-repository ppa:gnome-terminator
# sudo apt-get update
# sudo apt-get install terminator
# # configs terminator
# mkdir -p ~/.config/terminator
# cp -r ~/.betafcc/dotfiles/.config/terminator ~/.config/terminator


# install kitty
KITTY_DIR=$HOME/.local/kitty.app
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin dest=$KITTY_DIR launch=n
ln -s $KITTY_DIR/bin/kitty $HOME/.local/bin/
cp $KITTY_DIR/share/applications/kitty.desktop $HOME/.local/share/applications
__icon_dir=$HOME/.local/share/icons/hicolor/256x256/apps
mkdir -p $__icon_dir
cp $KITTY_DIR/share/icons/hicolor/256x256/apps/kitty.png $__icon_dir


# better terminal fonts
sudo apt-get install -y fonts-powerline
# better yet https://github.com/tonsky/FiraCode
sudo apt install -y fonts-firacode
# even better: patched for nerd icons
curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip
unzip FiraCode.zip  -d $HOME/.local/share/fonts/
rm FiraCode.zip
fc-cache -f -v  # cache clean


# install emacs
sudo add-apt-repository -y ppa:kelleyk/emacs
sudo apt update
sudo apt install -y emacs26
# set up 24 bit color capability
# see https://github.com/syl20bnr/spacemacs/wiki/Terminal
tic -x -o $HOME/.terminfo $HOME/.betafcc/misc/xterm-24bit.terminfo


# install sublime text 3
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install -y sublime-text


# install chrome
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
sudo apt update
sudo apt install google-chrome-stable


# install elementary tweaks
sudo add-apt-repository -y ppa:philip.scott/elementary-tweaks
sudo apt update
sudo apt install -y elementary-tweaks


# install dconf
sudo apt install dconf-tools


# install docker
curl -fsSL get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
exec "$SHELL"


# sets up python
sudo apt install -y \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo '' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
exec "$SHELL"
last_version=$(pyenv install --list | grep -P '^\s+\d+\.\d+\.\d+$' | tail -1)
pyenv install $last_version
pyenv global $last_version
python -m pip install pip --upgrade
python -m pip install ipython pipenv
echo '' >> ~/.bashrc
echo 'eval "$(pipenv --completion)"' >> ~/.bashrc
exec "$SHELL"

# non official python tools
# need the system python until pipsi is installed
pyenv shell system
curl https://bootstrap.pypa.io/get-pip.py | sudo -H python
sudo -H pip install virtualenv
curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python
pyenv shell --unset

# poetry
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
exec "$SHELL"
poetry completions bash | sudo tee /etc/bash_completion.d/poetry.bash-completion 1>/dev/null
exec "$SHELL"

# black
pipsi install black


# sets up node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
exec "$SHELL"
nvm install node


# sets up php
sudo apt install -y \
    php7.0 \
    php7.0-curl \
    php7.0-json \
    php7.0-cgi \
    php7.0-fpm \
    autoconf \
    automake \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    openssl \
    gettext \
    libicu-dev \
    libmcrypt-dev \
    libmcrypt4 \
    libbz2-dev \
    libreadline-dev \
    build-essential \
    libmhash-dev \
    libmhash2 \
    libxslt1-dev
# configure: error: To enable code coverage reporting you must have LTP installed
sudo apt install -y lcov
# configure: error: Cannot find sys/sdt.h which is required for DTrace support
sudo apt install -y systemtap-sdt-dev
# configure: error: Cannot find ldap.h
sudo apt install -y libldb-dev libldap2-dev
sudo ln -s /usr/lib/x86_64-linux-gnu/libldap* /usr/lib/
sudo ln -s /usr/lib/x86_64-linux-gnu/liblber* /usr/lib/
# continue
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
sudo mv phpbrew /usr/local/bin/phpbrew
phpbrew init
echo '' >> ~/.bashrc
echo "[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc" >> ~/.bashrc
exec "$SHELL"
phpbrew update
last_version=$(phpbrew known | grep -oP '\d+\.\d+\.\d+' | head -1)
phpbrew install -j $(nproc) $last_version +default
phpbrew switch $last_version


# sets up haskell
curl -sSL https://get.haskellstack.org/ | sh
echo '' >> ~/.bashrc
echo 'eval "$(stack --bash-completion-script stack)"' >> ~/.bashrc
echo 'main = putStrLn "ghc installed"' | stack -j $(nproc) runghc


# sets up java
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
last_version=$(jabba ls-remote | grep -P '^\d+\.\d+.\d+$' | head -1)
jabba install $last_version
jabba alias default $last_version
exec "$SHELL"


# sets up asdf
sudo apt install -y \
    automake \
    autoconf \
    libreadline-dev \
    libncurses-dev \
    libssl-dev \
    libyaml-dev \
    libxslt-dev \
    libffi-dev \
    libtool \
    unixodbc-dev
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
exec "$SHELL"


# sets up erlang
# # optional wx (I couldn't make it work)
# sudo apt-key adv --fetch-keys http://repos.codelite.org/CodeLite.asc
# sudo apt-add-repository 'deb http://repos.codelite.org/wx3.0.4/ubuntu/ xenial universe'
# sudo apt update
# sudo apt-get install -y \
#     libwxbase3.0-0-unofficial \
#     libwxbase3.0-dev \
#     libwxgtk3.0-0-unofficial \
#     libwxgtk3.0-dev \
#     wx3.0-headers \
#     wx-common \
#     libwxbase3.0-dbg \
#     libwxgtk3.0-dbg \
#     wx3.0-i18n \
#     wx3.0-examples \
#     wx3.0-doc
asdf plugin-add erlang
last_version=$(asdf list-all erlang | grep -oP '^\d+\.\d+\.\d+$' | tail -1)
asdf install erlang $last_version
asdf global erlang $last_version


# sets up elixir
asdf plugin-add elixir
last_version=$(asdf list-all elixir | grep -oP '^\d+\.\d+\.\d+$' | tail -1)
asdf install elixir $last_version
asdf global elixir $last_version


# sets up rebar
asdf plugin-add rebar
# rebar
last_version=$(asdf list-all rebar | grep -oP '^2\.\d+\.\d+$' | tail -1)
asdf install rebar $last_version
# rebar3
last_version=$(asdf list-all rebar | grep -oP '^3\.\d+\.\d+$' | tail -1)
asdf install rebar $last_version
asdf global rebar $last_version


# sets up rust
sh <(curl https://sh.rustup.rs -sSf) -y


# sets my bash commands
echo '' >> ~/.bashrc
echo ". ~/.betafcc/bashrc" >> ~/.bashrc
exec "$SHELL"


# Removes plank and wingpanel from auto respawn
dconf write '/org/pantheon/desktop/cerbere/monitored-processes' "@as []"


# double click to open stuff
gsettings set org.pantheon.files.preferences single-click false


# installs hub
sudo add-apt-repository -y ppa:cpick/hub
sudo apt update
sudo apt install -y hub


# configs git
cp ~/.betafcc/dotfiles/.gitconfig ~/


# tweaks gtk theme
sudo cp -r /usr/share/themes/elementary/gtk-3.0 /usr/share/themes/elementary/gtk-3.0.bak
sudo cp misc/gtk-3.0/* /usr/share/themes/elementary/gtk-3.0/


# installs vlc
sudo apt-add-repository -y ppa:videolan/stable-daily
sudo apt update
sudo apt install -y vlc


# paint equivalent
sudo apt install -y pinta


# task manager
sudo apt install -y gnome-system-monitor htop


# Disk usage analyzer
sudo apt install -y baobab


# Set up .desktop file open
# https://bugs.launchpad.net/ubuntu/+source/gvfs/+bug/378783
sudo apt install -y dex
sudo cp ~/.betafcc/misc/dex.desktop /usr/share/applications/


# Powerline
# pipsi install powerline-shell
# echo -e '\nfunction _update_ps1() {\n    PS1=$(powerline-shell $?)\n}\n'
# echo -e '\nif [[$TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1]]; then\n    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"\nfi'
cargo install powerline-rs
exec "$SHELL"


# Better than ls
sudo apt install -y cmake
# cargo install exa
# PR with --icons support
git clone https://github.com/ogham/exa.git && cd exa
git fetch origin pull/368/head:pr-368
git checkout pr-368
cargo install
cd .. && rm -rf exa


# Fucking Rust and their awesome community
# https://github.com/sharkdp/bat
# better than cat
cargo install bat


# Awesome file manager https://github.com/ranger/ranger
python -m pip install pillow  # for image-preview
python -m pip install ranger-fm
exec "$SHELL"
# As it says the method of configuration may change
# Remember to set up image preview manually
# as of now:
#    ranger --copy-config=which all
#
#    then  open ~/.config/ranger/rc.conf and change image_previews to true and method to kitty
#    also, the comments there say to put this in .bashrc
#    export RANGER_LOAD_DEFAULT_RC=FALSE

# add devincons to it
git clone https://github.com/alexanderjeurissen/ranger_devicons
cd ranger_devicons
make install
cd ..
rm -rf ranger_devicons


# Awesomeness fzf + fd
cargo install fd-find
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# Set up japanese keyboard
sudo apt install -y \
    fcitx \
    fcitx-mozc \
    fcitx-frontend-all \
    fcitx-frontend-gtk3 \
    imagemagick \
    im-config
sudo convert -resize 16x16 \
    /usr/share/fcitx/mozc/icon/mozc.png \
    /usr/share/fcitx/mozc/icon/mozc.png
cp ~/.betafcc/dotfiles/.config/fcitx/* ~/.config/fcitx/


# better than grep
cargo install ripgrep


# Recomended swappiness is 10, default is 60 for some reason
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf


## open default applications settings and wait user exit
# switchboard settings://applications


## open im-config to activate fcitx japanese keyboard
# im-config


# links custom binaries to /usr/local/bin
find \
    $(readlink -f ~/.betafcc/misc/bin) \
    -maxdepth 1 \
    -type f |
    while read -r
    do
        sudo ln -s "${REPLY}" /usr/local/bin
    done
