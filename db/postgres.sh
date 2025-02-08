#/bin/bash

site=$1

# Postgres
pw=`pwgen 16 1`
db=`echo "$site" | sed 's/\./_/g'`
user=$db

su postgres -c "createuser $user -d -e -S -R"
su postgres -c "psql -c \"ALTER USER \\\"$user\\\" WITH PASSWORD '$pw'\" -e"

su postgres -c "createdb $db -e -E utf8 -O $user"
su postgres -c "createdb test-$db -e -E utf8 -O $user"

renv=${RAILS_ENV:-production}

config=$(
cat <<DOC
$renv:
  adapter:  postgresql

  database: "$db"
  username: "$user"
  password: "$pw"
  host:     localhost

  encoding: unicode

  pool: 5
  timeout: 5000

test:
  adapter:  postgresql

  database: "test-$db"
  username: "$user"
  password: "$pw"
  host:     localhost

  encoding: unicode

  pool: 5
  timeout: 5000
DOC
)

echo "$config" > /etc/databases/$site.yml

cat <<DOC > /etc/databases/$site.sh
# Usage: source /etc/databases/$site.sh; PGPASSWORD=$PGPASSWORD psql -h "$PGHOST" -U "$PGUSER" "$PGDATABASE"
PGDATABASE="$db"
PGUSER="$user"
PGPASSWORD="$pw"
PGHOST="localhost"
DOC

chown www:www /etc/databases/$site.*

echo -e "\nYour database configuration was written to /etc/databases/$site.yml"
