#!/bin/bash

# Простой скрипт для ручного деплоя
# Запускается на сервере: ./deploy.sh

set -e

echo "🚀 Обновление сайта..."

cd /var/www/site
git pull origin main
cp relocation-website.html /var/www/html/index.html

echo "✅ Готово! Обновлено в $(date)"
