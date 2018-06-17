# sets this repository locally, will use it later in this very script
sudo apt install -y git
git clone https://github.com/betafcc/eos-bootstrapping.git ~/.betafcc


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


# pass the rest of setup to python
cd ~/.betafcc
pipenv install
pipenv run python -m install
