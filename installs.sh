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


# sets basic git
git config --global user.email "betafcc@gmail.com"
git config --global user.name "Beta Faccion"
