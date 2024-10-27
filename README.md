# Защита сервера

Подробное руководство по настройке безопасности арендованных серверов: установка ПО, настройка брандмауэра, защита от атак и мониторинг серверов.

## Содержание
- [Описание](#описание)
- [Установка](#установка)
  - [Шаг 1: Установка базовых утилит](#шаг-1-установка-базовых-утилит)
  - [Шаг 2: Установка дополнительного ПО](#шаг-2-установка-дополнительного-по)
  - [Шаг 3: Конфигурация SSH](#шаг-3-конфигурация-ssh)
- [Использование](#использование)
- [Руководство](#руководство)
  - [1. Установка ПО](#1-установка-по)
  - [2. Настройка брандмауэра](#2-настройка-брандмауэра)
  - [3. Защита от атак](#3-защита-от-атак)
  - [4. Мониторинг](#4-мониторинг)
- [Контакты и поддержка](#контакты-и-поддержка)
- [Лицензия](#лицензия)

## Описание
`server-protection` — это руководство для системных администраторов, разработчиков, владельцев бизнеса и студентов, которое включает практики по укреплению безопасности арендованных серверов, а также подробные инструкции по установке, настройке и мониторингу.

## Установка

### Шаг 1: Установка базовых утилит
Обновите систему и установите базовые инструменты управления сервером:

#### Для Debian/Ubuntu:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim git curl ufw fail2ban
```
#### Для Red Hat/CentOS:

```bash
sudo yum update -y
sudo yum install -y vim git curl firewalld fail2ban

```
### Установка дополнительного ПО

### Установка Fail2Ban
Fail2Ban блокирует IP-адреса, которые пытаются совершать брутфорс-атаки.

#### Для Debian/Ubuntu:
```bash
sudo apt install -y fail2ban
```

## Конфигурация SSH

### Шаг 2 Отключение входа по паролю

Отключите вход по паролю, чтобы предотвратить атаки грубой силы. Используйте аутентификацию по SSH-ключам.

1. Откройте файл конфигурации SSH:
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
2. Измените параметры:
   ```plaintext
   PermitRootLogin no
   PasswordAuthentication no
   ```
3. Сохраните изменения и перезапустите SSH:
   ```bash
   sudo systemctl restart sshd
   ```

### Изменение порта SSH

Для дополнительной защиты измените стандартный порт 22 на нестандартный (например, 2222).

1. Откройте файл конфигурации SSH:
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
2. Измените параметр порта:
   ```plaintext
   Port <номер_порта>
   ```
3. Перезапустите SSH:
   ```bash
   sudo systemctl restart sshd
   ```

## Настройка брандмауэра

### Для Debian/Ubuntu с использованием UFW:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow <номер_порта_для_ssh>
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

### Для Red Hat/CentOS с использованием Firewalld:
```bash
sudo firewall-cmd --permanent --add-port=<номер_порта_для_ssh>/tcp
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## Защита от атак

### Настройка Fail2Ban

1. Откройте файл конфигурации:
   ```bash
   sudo nano /etc/fail2ban/jail.local
   ```
2. Настройте параметры для SSH:
   ```plaintext
   [sshd]
   enabled = true
   port = <номер_порта_для_ssh>
   filter = sshd
   logpath = /var/log/auth.log
   maxretry = 3
   bantime = 3600
   ```
3. Сохраните изменения и перезапустите Fail2Ban:
   ```bash
   sudo systemctl restart fail2ban
   ```

## Мониторинг

Настройте мониторинг для получения отчетов о состоянии сервера и производительности.

### Установка и настройка Logwatch

1. Установите logwatch:
   ```bash
   sudo apt install logwatch
   ```
2. Настройте отправку отчетов:
   ```bash
   sudo logwatch --detail High --mailto <ваш_email> --output mail
   ```

### Использование утилит top, htop и iotop

Для мониторинга производительности сервера используйте утилиты `top`, `htop` и `iotop`.

1. Установите их:
2. 
   ```bash
   sudo apt install htop iotop
   ```
3. Запустите мониторинг:
   ```bash
   htop
   iotop
   ```

