# apt misc setup
sudo apt update
sudo apt full-upgrade
sudo apt install -y software-properties-common


# install termite
curl -s https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | sh
rm -rf termite vte-ng


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


# sets up python
sudo apt-get install -y \
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
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
sudo mv phpbrew /usr/local/bin/phpbrew


# sets basic git
git config --global user.email "betafcc@gmail.com"
git config --global user.name "Beta Faccion"
