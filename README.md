# Rented Server Protection

Подробное руководство по настройке безопасности арендованных серверов: установка ПО, настройка брандмауэра, защита от атак и мониторинг серверов.

## Содержание
- [Описание](#описание)
- [Установка](#установка)
- [Использование](#использование)
- [Руководство](#руководство)
  - [1. Установка ПО](#установка-по)
  - [2. Настройка брандмауэра](#настройка-брандмауэра)
  - [3. Защита от атак](#защита-от-атак)
  - [4. Мониторинг](#мониторинг)
- [Контакты и поддержка](#контакты-и-поддержка)
- [Лицензия](#лицензия)

## Описание
`rented-server-protection` — это руководство для системных администраторов, разработчиков и владельцев серверов, которое включает практики по укреплению безопасности арендованных серверов.

## Установка
Инструкции по установке и настройке ПО...

## Использование
Примеры использования и советы по настройке...

## Руководство
### 1. Установка ПО
Детальное руководство по установке программного обеспечения...

### 2. Настройка брандмауэра
Шаги по настройке брандмауэра для повышения безопасности...

### 3. Защита от атак
Практики и инструменты для защиты от различных видов атак...

### 4. Мониторинг
Как настроить мониторинг и отслеживать активность на сервере...

## Контакты и поддержка
Связаться с автором проекта: [email@example.com](mailto:email@example.com)

## Лицензия
Этот проект лицензирован под MIT License.
![Настройка брандмауэра](assets/images/firewall-setup.png)

#!/bin/bash

# Скрипт по настройке безопасности арендованного сервера

# Обновление системы
echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

# Установка базовых утилит
echo "Установка базовых утилит..."
sudo apt install -y curl wget git vim ufw fail2ban

# Создание нового пользователя
read -p "Введите имя нового пользователя для администратора: " adminuser
sudo adduser $adminuser
sudo usermod -aG sudo $adminuser

# Настройка SSH-доступа
echo "Настройка SSH-доступа..."
mkdir -p /home/$adminuser/.ssh
read -p "Введите ваш публичный SSH-ключ: " sshkey
echo $sshkey > /home/$adminuser/.ssh/authorized_keys
sudo chown -R $adminuser:$adminuser /home/$adminuser/.ssh
sudo chmod 600 /home/$adminuser/.ssh/authorized_keys

# Отключение root-доступа по SSH
echo "Отключение доступа root по SSH..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Настройка брандмауэра UFW
echo "Настройка брандмауэра UFW..."
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Установка и настройка Fail2Ban
echo "Установка и настройка Fail2Ban..."
sudo apt install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i 's/\[sshd\]/\[sshd\]\nenabled = true\nport = ssh\nlogpath = %(sshd_log)s\nmaxretry = 5\nbantime = 600/' /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

# Установка Netdata для мониторинга
echo "Установка Netdata..."
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

echo "Настройка безопасности сервера завершена успешно!"

