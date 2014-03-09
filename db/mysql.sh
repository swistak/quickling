site=$1
pw=`pwgen 16 1`
db=`echo "$site" | sed 's/\./_/g'`
user=${db:0:16}

echo "Creating mysql database. Logging in as root"
mysql -u root -p -vv <<SQL
CREATE DATABASE ${db};
CREATE USER ${user}@localhost;
SET PASSWORD FOR ${user}@localhost= PASSWORD("${pw}");
GRANT ALL PRIVILEGES ON ${db}.* TO ${user}@localhost IDENTIFIED BY '${pw}';

FlUSH PRIVILEGES;
SQL

echo "Your database configuration:"

config=$(
cat <<CONFIG
/** The name of the database for WordPress */
define('DB_NAME', '$db');

/** MySQL database username */
define('DB_USER', '$user');

/** MySQL database password */
define('DB_PASSWORD', '$pw');
CONFIG
)

echo "$config" | tee /etc/databases/$site.php

cat <<DOC >> /etc/databases/$site.sh
database="$db"
username="$user"
password="$pw"
host="localhost"
DOC


echo -e "\nYour database configuration was also written to /etc/databases/$site.php"

