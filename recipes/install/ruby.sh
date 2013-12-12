# [TODO] Think about permissions especially to /srv chown it to www ?.
# [TODO] Reorganize it, so the ruby installation is a separate step, then nginx is another, then db

aptitude update

aptitude install build-essential openssl libreadline6 libreadline6-dev curl \
  git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 \
  libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool \
  bison git pwgen vim libcurl4-openssl-dev

chmod 777 /opt

adduser www
su www

cd ~

curl -L get.rvm.io | bash -s stable

# echo >> .bashrc
# echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*' >> .bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

rvm install 1.9.3
rvm 1.9.3

gem install passenger bundler

passenger-install-nginx-module
mkdir /var/log/nginx

mkdir -p /srv/default
touch /srv/default/index.html

exit # Back to root

cd /opt

mv /opt/nginx/conf/ /etc/nginx
ln -s /etc/nginx/ /opt/nginx/conf

wget -O init-deb.sh http://library.linode.com/assets/600-init-deb.sh
mv init-deb.sh /etc/init.d/nginx
chmod +x /etc/init.d/nginx
/usr/sbin/update-rc.d -f nginx defaults

/etc/init.d/nginx start

aptitude install postgresql-9.1 postgresql-client-9.1 libpq-dev
