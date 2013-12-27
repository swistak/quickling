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

echo "Loading rvm"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

if [ -e ".rvmrc" ]; then
  source .rvmrc && echo "Loaded .rvmrc" || echo "Error when loading .rvmrc"
elif [ -e ".ruby-version" ]; then
  cd .; # T_T why autoloading of .ruby-version works on my machine and not here (and you need fucking cd .) is beyound me
  echo "Using .ruby-version and .ruby-gemset"
else 
  echo "Loading 1.9.3"
  rvm 1.9.3
fi

echo "I am `whoami` on `rvm-prompt`"

if [ -e Gemfile ]; then
  echo "Instaling bundle"
  bundle install --without development | grep -v Using
fi

dbfile="/etc/databases/%domain.yml"
if [ -d config ] && [ -e $dbfile ]; then
  echo "Setting up database.yml"
  cp $dbfile config/database.yml
fi

if [ -e Rakefile ] && [ -d db/migrate ]; then
  echo "Migrating"
  bundle exec rake db:migrate
  # [check] what if there's no bundle?
fi

if [ -d tmp ]; then
  echo "Restarting passenger."
  touch tmp/restart.txt
fi

read oldrev newrev refname
if [ ! -z "`git diff --name-only $oldrev..$newrev | grep 'assets'`" ]; then
  echo "Rebuilding assets"
  rm -rf public/assets/*;
  rake assets:precompile --trace
fi

if [ -e script/restart.sh ]; then
  echo "Restarting mongrel server."
  script/restart.sh
fi

