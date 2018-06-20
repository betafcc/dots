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


# sets this repository locally, will use it later in this very script
git clone https://github.com/betafcc/eos-bootstrapping.git ~/.betafcc


# # install termite
# curl -s https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | sh
# rm -rf termite vte-ng


# install terminator
sudo add-apt-repository ppa:gnome-terminator
sudo apt-get update
sudo apt-get install terminator


# install emacs
sudo add-apt-repository -y ppa:ubuntu-elisp/ppa
sudo apt update
sudo apt install -y emacs25


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


# sets up rust
sh <(curl https://sh.rustup.rs -sSf) -y


# sets my bash commands
echo '' >> ~/.bashrc
echo "source ~/.betafcc/bashrc" >> ~/.bashrc
exec "$SHELL"


# Removes plank
path='/org/pantheon/desktop/cerbere/monitored-processes'
new_value=$(dconf read $path | tr \' \" | jq -c '. - ["plank"]' | tr \" \')
dconf write $path "$new_value"


# configs git
cp ~/.betafcc/dotfiles/.gitconfig ~/


# tweaks gtk theme
sudo cp -r /usr/share/themes/elementary/gtk-3.0 /usr/share/themes/elementary/gtk-3.0.bak
sudo cp misc/gtk-3.0/* /usr/share/themes/elementary/gtk-3.0/
