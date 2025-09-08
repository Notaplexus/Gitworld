#!/bin/bash
set -e

# Конфигурация
MC_VERSION="1.21.8"
MC_JAR="server.jar"
MC_URL="https://piston-data.mojang.com/v1/objects/4c3f0e3b9d8f6e93ee9a8e3e13b430bbd9d5a521/server.jar"

# 1. Скачиваем jar если его нет
if [ ! -f $MC_JAR ]; then
  echo "Скачиваю Minecraft $MC_VERSION ..."
  curl -o $MC_JAR $MC_URL
fi

# 2. Принимаем EULA
if [ ! -f eula.txt ]; then
  echo "eula=true" > eula.txt
fi

# 3. Настраиваем git если не было
git config --global user.name "codespaces"
git config --global user.email "codespaces@github.com"

# 4. Делаем первую структуру
mkdir -p backups

# 5. Первый коммит если репо пустое
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git add .
  git commit -m "Initial commit: Minecraft $MC_VERSION server setup"
  git push || true
fi

# 6. Фоновый бэкап-цикл
(
  while true; do
    sleep 180
    TS=$(date +"%Y-%m-%d_%H-%M-%S")
    echo "Создаю бэкап: $TS"
    ZIPFILE="backups/world-$TS.zip"
    zip -r "$ZIPFILE" world/ >/dev/null 2>&1 || echo "Мир ещё не создан"
    git add backups/
    git commit -m "Backup $TS" || echo "Нет изменений для коммита"
    git push || echo "Не удалось запушить"
  done
) &

# 7. Запуск сервера
echo "Запускаю Minecraft $MC_VERSION ..."
exec java -Xmx2G -Xms1G -jar $MC_JAR nogui
