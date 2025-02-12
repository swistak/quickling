#!/bin/bash

# An example hook script for the "post-receive" event.
#
# The "post-receive" script is run after receive-pack has accepted a pack
# and the repository has been updated.  It is passed arguments in through
# stdin in the form
#  <oldrev> <newrev> <refname>
# For example:
#  aa453216d1b3e49e7f6f98441fa56946ddcd6a20 68f7abf4e6f922807889f52bc043ecd31b79f814 refs/heads/master
#
# see contrib/hooks/ for a sample, or uncomment the next line and
# rename the file to "post-receive".

#. /usr/share/doc/git-core/contrib/hooks/post-receive-email

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  echo "Loading $HOME/.rvm/scripts/rvm"
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/etc/profile.d/rvm.sh" ]]; then
  echo "Loading /etc/profile.d/rvm.sh"
  source "/etc/profile.d/rvm.sh"
else
  echo "Could not find .rvm"
  exit 1
fi

rvm use .

export RAILS_ENV="production"
echo "I am user: `whoami`. Rails env: $RAILS_ENV"

read oldrev newrev refname

if [ -e Gemfile ]; then
  echo "Instaling bundle"
  BUNDLE_WITHOUT=development BUNDLE_DEPLOYMENT=1 bundle install | grep -v Using
fi

dbfile="/etc/databases/%domain.yml"
if [ -d config ] && [ -e $dbfile ]; then
  echo "Setting up database.yml"
  cp $dbfile config/database.yml
fi

if [ -e Rakefile ] && [ -d db/migrate ] && [ ! -z "`git diff --name-only $oldrev..$newrev | grep 'db/migrate'`" ]; then
  echo "Migrating"
  bundle exec rake db:migrate
fi

if [ -d public/assets ] && [ ! -z "`git diff --name-only $oldrev..$newrev | grep 'assets'`" ]; then
  echo "Rebuilding assets"
  rm -rf public/assets/*;
  bundle exec rake assets:precompile --trace
fi

if [ -f tmp/restart.txt ]; then
  echo "Restarting passenger / using tmp/restart.txt"
  touch tmp/restart.txt
fi

if [ -e script/restart.sh ]; then
  echo "Restarting using script/restart.sh"
  script/restart.sh
fi
