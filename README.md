# quickling

A set of scripts for staging servers, allowing for rapid deployments and setup of new sites.

## Installing on server

### Update everything

```
apt update && apt upgrade
```

### Generate ssh key

```bash
mkdir .ssh
chmod 700 .ssh
cd .ssh
echo "Public Key from your local machine" > authorized_keys
chmod 600 authorized_keys
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Add _public_ key to https://github.com/settings/keys

### Clone repo

```bash
cd ~
git@github.com:swistak/quickling.git
```

### Install RVM

If on ubuntu:  https://github.com/rvm/ubuntu_rvm

If not: https://rvm.io/rvm/install

#### Update to newest version of RVM:

```
sudo gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
rvmsudo rvm get master
```

#### Install Ruby for main user

Add main user to rvm group: `sudo usermod -a -G rvm $USER`

Instll ruby eg. `rvm install 3.4`

### Create www user

Secondary unpriviliged user with no access to sudo

```bash
sudo adduser www --disabled-password --comment "WWW User"
sudo usermod -a -G rvm www
sudo su www
cd ~
mkdir .ssh
chmod 700 .ssh
cd .ssh
echo "Public Key from your local machine" > authorized_keys
chmod 600 authorized_keys
```
