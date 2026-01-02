# Deployment Guide

This guide will help you set up automatic deployment from GitHub to your VPS server.

## Prerequisites

- VPS with SSH access
- Git installed on server
- Web server (nginx/apache) configured
- GitHub repository access

## Quick Setup (5 minutes)

### 1. Server Setup

SSH into your server and run these commands:

```bash
# Install git if not installed
sudo apt update && sudo apt install -y git

# Create project directory
sudo mkdir -p /var/www/site
sudo chown $USER:$USER /var/www/site

# Clone repository
cd /var/www/site
git clone git@github.com:vitvickaya111-blip/site.git .

# Make deploy script executable
chmod +x deploy.sh

# Copy website to web root
sudo cp relocation-website.html /var/www/html/index.html
```

### 2. Generate SSH Key for GitHub Actions

On your **local machine**, generate a new SSH key pair:

```bash
# Generate SSH key (no passphrase)
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/github_deploy_key -N ""

# Display private key (you'll add this to GitHub Secrets)
cat ~/.ssh/github_deploy_key

# Display public key (you'll add this to your server)
cat ~/.ssh/github_deploy_key.pub
```

### 3. Add Public Key to Server

On your **server**, add the public key to authorized_keys:

```bash
# Add public key to authorized_keys
echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys

# Set correct permissions
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 4. Configure GitHub Secrets

Go to your GitHub repository:
**Settings → Secrets and variables → Actions → New repository secret**

Add these secrets:

| Secret Name | Value | Example |
|------------|-------|---------|
| `SERVER_HOST` | Your server IP or domain | `123.45.67.89` or `example.com` |
| `SERVER_USER` | SSH username | `root` or `ubuntu` |
| `SSH_PRIVATE_KEY` | Content of `~/.ssh/github_deploy_key` | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `SERVER_PORT` | SSH port (optional, default: 22) | `22` |
| `PROJECT_PATH` | Path on server (optional) | `/var/www/site` |

### 5. Test Deployment

Push a change to the `main` branch or manually trigger the workflow:

1. Go to **Actions** tab in GitHub
2. Select **Deploy to Server** workflow
3. Click **Run workflow**
4. Check deployment logs

## Manual Deployment

If you need to deploy manually, SSH into your server and run:

```bash
cd /var/www/site
./deploy.sh
```

## Web Server Configuration

### Nginx Configuration

Create `/etc/nginx/sites-available/site`:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Optional: Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Apache Configuration

Create `/etc/apache2/sites-available/site.conf`:

```apache
<VirtualHost *:80>
    ServerName your-domain.com
    ServerAlias www.your-domain.com
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/site-error.log
    CustomLog ${APACHE_LOG_DIR}/site-access.log combined
</VirtualHost>
```

Enable the site:

```bash
sudo a2ensite site.conf
sudo systemctl reload apache2
```

## SSL Certificate (HTTPS)

Set up free SSL with Let's Encrypt:

```bash
# Install certbot
sudo apt install -y certbot python3-certbot-nginx  # For nginx
# OR
sudo apt install -y certbot python3-certbot-apache  # For apache

# Get certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com  # For nginx
# OR
sudo certbot --apache -d your-domain.com -d www.your-domain.com  # For apache

# Auto-renewal is configured automatically
```

## Troubleshooting

### Deployment fails with SSH error

1. Check SSH key is correct in GitHub Secrets
2. Verify public key is in `~/.ssh/authorized_keys` on server
3. Test SSH connection manually: `ssh -i ~/.ssh/github_deploy_key user@server`

### Files not updating on website

1. Check file permissions: `ls -la /var/www/html`
2. Clear browser cache (Ctrl+Shift+R)
3. Check web server is serving correct directory

### Git pull fails on server

1. Ensure git is installed: `git --version`
2. Check repository permissions: `ls -la /var/www/site`
3. Reset repository: `cd /var/www/site && git reset --hard origin/main`

### Permission denied errors

```bash
# Fix project directory permissions
sudo chown -R $USER:$USER /var/www/site

# Fix web root permissions
sudo chown -R www-data:www-data /var/www/html  # For nginx/apache
```

## Monitoring Deployments

- **GitHub Actions**: Check the Actions tab for deployment logs
- **Server logs**: `journalctl -u nginx -f` or `journalctl -u apache2 -f`
- **Deploy script logs**: Check output when running `./deploy.sh`

## Rollback

To rollback to a previous version:

```bash
cd /var/www/site

# View available backups
ls -lh /var/backups/site/

# Restore from backup
tar -xzf /var/backups/site/backup-YYYYMMDD-HHMMSS.tar.gz -C /var/www/site

# Or rollback git to specific commit
git log --oneline  # Find commit hash
git reset --hard COMMIT_HASH
./deploy.sh
```

## Security Best Practices

1. **Use SSH keys**, not passwords
2. **Disable password authentication** in `/etc/ssh/sshd_config`
3. **Use firewall**: `sudo ufw enable && sudo ufw allow 22,80,443/tcp`
4. **Keep system updated**: `sudo apt update && sudo apt upgrade`
5. **Use HTTPS** with SSL certificate
6. **Limit SSH access** to specific IPs if possible

## Support

For issues:
1. Check GitHub Actions logs
2. Check server logs: `tail -f /var/log/nginx/error.log`
3. Test manual deployment: `cd /var/www/site && ./deploy.sh`
