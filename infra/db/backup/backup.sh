#!/usr/bin/env bash
set -euo pipefail

TS=$(date +"%Y%m%d_%H%M")
OUT_DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="$OUT_DIR/lifeops_${TS}.dump"

echo "[backup] starting: $FILE"

pg_dump \
  -h localhost \
  -p 15432 \
  -U lifeops \
  -d lifeops \
  -Fc \
  -f "$FILE"

echo "[backup] done"