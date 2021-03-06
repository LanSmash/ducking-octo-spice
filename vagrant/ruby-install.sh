cd ~
git clone git://github.com/sstephenson/rbenv.git .rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
eval "$(rbenv init -)"

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

rbenv install 2.2.2
rbenv global 2.2.2
ruby -v

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler

#http://www.sitepoint.com/uno-use-sinatra-implement-rest-api/
gem install sinatra 
gem install thin
gem install rest-client
