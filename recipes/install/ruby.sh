# [TODO] Think about permissions especially to /srv chown it to www ?.
# [TODO] Reorganize it, so the ruby installation is a separate step, then nginx is another, then db

sudo -i

apt update && apt upgrade

apt install build-essential openssl libreadline6-dev curl \
  git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 \
  libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool \
  bison git pwgen vim libcurl4-openssl-dev \
  gawk, libffi-dev, libgdbm-dev, libncurses5-dev, pkg-config, libgmp-dev

chmod 777 /opt

adduser www --disabled-password --gecos ""
usermod -a -G sudo www

# RVM
su www

gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
cd ~
curl -L get.rvm.io | bash -s stable
source /home/www/.rvm/scripts/rvm

rvm install 2.6
rvm use 2.6

gem install bundler
