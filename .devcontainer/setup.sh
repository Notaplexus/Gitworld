#!/bin/bash

# Установка необходимых пакетов
apt-get update
apt-get install -y wget npm git

# Скачивание Vanilla сервера 1.21.8
wget -O server.jar https://piston-data.mojang.com/v1/objects/4e35a2f9b8d71e491b0853b09a7b5f6f587c7eb7/server.jar

# Установка ngrok для туннелирования
npm install -g ngrok

# Создание папок для бэкапов
mkdir -p backups
mkdir -p world

# Настройка Git
git config --global user.email "minecraft@server.com"
git config --global user.name "Minecraft Server"
