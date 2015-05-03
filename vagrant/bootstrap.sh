sudo apt-get update

apt-get -y install vim git curl
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev

# install ruby as vagrant user
sudo -u vagrant -H sh -c "/vagrant/ruby-install.sh"

