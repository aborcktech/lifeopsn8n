#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: restore.sh <backup_file.dump>"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "[restore] file not found: $FILE"
  exit 1
fi

echo "[restore] restoring from $FILE"

pg_restore \
  -h localhost \
  -p 15432 \
  -U lifeops \
  -d lifeops \
  --clean \
  --if-exists \
  "$FILE"

echo "[restore] done"
