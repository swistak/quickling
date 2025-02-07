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

AAdd _public_ key to https://github.com/settings/keys

### Clone repo

```bash
sudo -i
git@github.com:swistak/quickling.git
```
