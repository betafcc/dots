# apt misc setup
sudo apt update
sudo apt full-upgrade
sudo apt install software-properties-common -y


# install termite
curl -s https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | sh
rm -rf termite vte-ng


# install emacs
sudo add-apt-repository ppa:ubuntu-elisp/ppa -y
sudo apt update
sudo apt install emacs25 -y


# install sublime text 3
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text -y


# install chrome
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
sudo apt update
sudo apt install google-chrome-stable


# install elementary tweaks
sudo add-apt-repository ppa:philip.scott/elementary-tweaks -y
sudo apt update
sudo apt install elementary-tweaks -y


# installs pyenv
sudo apt-get install -y \
    make build-essential libssl-dev \
    zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev
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


# sets basic git
git config --global user.email "betafcc@gmail.com"
git config --global user.name "Beta Faccion"
