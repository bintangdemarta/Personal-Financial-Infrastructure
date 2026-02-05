#!/bin/bash
# Description: Restore MariaDB from a backup file (with safety prompt)

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 backups/db_YYYYMMDD_HHMM.sql.gz"
  exit 1
fi

BACKUP_FILE="$1"
CONTAINER="firefly_db"
DB_USER="fin_admin"
DB_PASS='9xL#m2$vP8qZ!wR5' # Matches .env
DB_NAME="firefly"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

read -r -p "This will overwrite the database '$DB_NAME'. Continue? [y/N] " ans
case "$ans" in
  y|Y) ;;
  *) echo "Aborted."; exit 1 ;;
esac

echo "[INFO] Restoring from $BACKUP_FILE"

gzip -dc "$BACKUP_FILE" | docker exec -i "$CONTAINER" /usr/bin/mysql -u "$DB_USER" --password="$DB_PASS" "$DB_NAME"

echo "[OK] Restore completed"
