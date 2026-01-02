#!/bin/bash

# Deployment script for relocation website
# This script should be run on your VPS server

set -e  # Exit on error

# Configuration
PROJECT_DIR="/var/www/site"
WEB_ROOT="/var/www/html"
BACKUP_DIR="/var/backups/site"
GIT_REPO="git@github.com:vitvickaya111-blip/site.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting deployment process...${NC}"

# Create backup
echo -e "${YELLOW}📦 Creating backup...${NC}"
mkdir -p "$BACKUP_DIR"
BACKUP_NAME="backup-$(date +%Y%m%d-%H%M%S).tar.gz"
if [ -d "$PROJECT_DIR" ]; then
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$PROJECT_DIR" . 2>/dev/null || true
    echo -e "${GREEN}✅ Backup created: $BACKUP_NAME${NC}"
fi

# Clone or pull repository
if [ -d "$PROJECT_DIR/.git" ]; then
    echo -e "${YELLOW}📥 Pulling latest changes...${NC}"
    cd "$PROJECT_DIR"
    git fetch origin
    git reset --hard origin/main
else
    echo -e "${YELLOW}📥 Cloning repository...${NC}"
    mkdir -p "$PROJECT_DIR"
    git clone "$GIT_REPO" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi

# Copy files to web root
echo -e "${YELLOW}📋 Copying files to web root...${NC}"
cp relocation-website.html "$WEB_ROOT/index.html"

# Set permissions
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
find "$WEB_ROOT" -type f -exec chmod 644 {} \;
find "$WEB_ROOT" -type d -exec chmod 755 {} \;

# Optional: Restart web server
# Uncomment the line for your web server
# sudo systemctl reload nginx
# sudo systemctl reload apache2

# Clean old backups (keep last 5)
echo -e "${YELLOW}🧹 Cleaning old backups...${NC}"
cd "$BACKUP_DIR"
ls -t backup-*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🕐 Deployed at: $(date)${NC}"
