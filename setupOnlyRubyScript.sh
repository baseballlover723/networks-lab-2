#NVM Installation
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
command -v nvm #Should say nvm
nvm install node
node -v #Verify node installation

#Ruby Installation
sudo apt-get update
sudo apt-get install curl
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -L https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
rvm -v #To check if worked
rvm install ruby-2.4.1
rvm use 2.4.1 --default
rvm uninstall 2.4.0
gem update
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.' >> ~/.bashrc

ruby -v
ruby -e "puts 'ruby is installed'"
