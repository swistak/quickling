# From https://www.digitalocean.com/community/articles/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-12-04
# and http://fak3r.com/2011/09/27/howto-install-php5-fpm-on-debian-squeeze/

srcs=<<DOC
deb http://packages.dotdeb.org stable all
deb-src http://packages.dotdeb.org stable all
DOC
echo "$srcs" >> /etc/apt/sources.list

wget http://www.dotdeb.org/dotdeb.gpg -q -O - | apt-key add -

apt-get update

aptitude install mysql-server
aptitude install php5-cli php5-suhosin php5-fpm php5-cgi php5-mysql

netstat -plunt|grep php # checks if php is running and on what port.

