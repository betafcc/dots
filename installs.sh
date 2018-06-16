# apt misc setup
sudo apt update
sudo apt install software-properties-common -y




# install termite
curl https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | sh
rm -rf termite vte-ng



# install chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable
