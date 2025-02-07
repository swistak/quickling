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

### Clone repo

```bash
git@github.com:swistak/quickling.git
```
