# Инструкция по деплою - Простая версия

Всего 3 шага, копируй команды и вставляй в терминал.

## Шаг 1: Настройка на сервере (5 минут)

Подключись к серверу и выполни эти команды:

```bash
ssh -i ~/.ssh/id_ed25519 root@92.246.128.158
```

Скопируй и вставь всё это целиком:

```bash
# Установка git (если нет)
apt update && apt install -y git

# Создание директории для сайта
mkdir -p /var/www/site
cd /var/www/site

# Клонирование репозитория
git clone https://github.com/vitvickaya111-blip/site.git .

# Создание директории для веб-сервера
mkdir -p /var/www/html

# Копирование файла сайта
cp relocation-website.html /var/www/html/index.html

# Установка прав
chmod 755 /var/www/html
chmod 644 /var/www/html/index.html

echo "✅ Сервер настроен!"
```

Готово! Отключись от сервера: `exit`

## Шаг 2: Настройка GitHub Secrets (2 минуты)

1. Открой свой репозиторий: https://github.com/vitvickaya111-blip/site
2. Перейди: **Settings → Secrets and variables → Actions**
3. Нажми **"New repository secret"**

Добавь только 1 секрет:

**Имя:** `SSH_PRIVATE_KEY`

**Значение:** Скопируй свой приватный ключ командой:

```bash
cat ~/.ssh/id_ed25519
```

Скопируй всё включая строки `-----BEGIN OPENSSH PRIVATE KEY-----` и `-----END OPENSSH PRIVATE KEY-----`

Нажми **Add secret**.

Готово!


---

## Установка веб-сервера (если ещё не установлен)

Выбери один вариант:

### Nginx (рекомендуется)

```bash
ssh -i ~/.ssh/id_ed25519 root@92.246.128.158
```

```bash
apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx

# Сайт доступен по http://92.246.128.158
```

### Apache

```bash
ssh -i ~/.ssh/id_ed25519 root@92.246.128.158
```

```bash
apt update
apt install -y apache2
systemctl start apache2
systemctl enable apache2

# Сайт доступен по http://92.246.128.158
```

---

## Проблемы?

### Сайт не обновляется

```bash
ssh -i ~/.ssh/id_ed25519 root@92.246.128.158
cd /var/www/site
git pull origin main
cp relocation-website.html /var/www/html/index.html
```

### GitHub Actions падает с ошибкой

1. Проверь что добавила `SSH_PRIVATE_KEY` в Secrets
2. Проверь что ключ скопирован полностью
3. Проверь сервер доступен: `ssh -i ~/.ssh/id_ed25519 root@92.246.128.158`

### Сайт не открывается

```bash
# Проверь что веб-сервер запущен
systemctl status nginx
# или
systemctl status apache2

# Перезапусти
systemctl restart nginx
# или
systemctl restart apache2
```

Всё!
