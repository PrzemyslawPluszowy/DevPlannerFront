#!/usr/bin/env bash

set -euo pipefail

SERVER_HOST="192.168.170.20"
SERVER_USER="root"
REMOTE_DIR="/var/www/ready_custom_flutter"
LOCAL_BUILD_DIR="build/web"

if [[ ! -d "$LOCAL_BUILD_DIR" ]]; then
  printf 'Brak katalogu %s. Najpierw uruchom: flutter build web --no-tree-shake-icons\n' "$LOCAL_BUILD_DIR" >&2
  exit 1
fi

printf 'Wysylam %s na %s@%s:%s\n' \
  "$LOCAL_BUILD_DIR" \
  "$SERVER_USER" \
  "$SERVER_HOST" \
  "$REMOTE_DIR"

rsync \
  -avz \
  --delete \
  --progress \
  -e ssh \
  "$LOCAL_BUILD_DIR/" \
  "$SERVER_USER@$SERVER_HOST:$REMOTE_DIR/"

printf '\nKopiowanie zakonczone.\n'
printf 'Nastepny krok: uruchomienie tymczasowego serwera na porcie 8088.\n'
