#!/bin/bash
# Description: Hot backup of MariaDB container
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M")
CONTAINER="firefly_db"
DB_USER="fin_admin"
DB_PASS='9xL#m2$vP8qZ!wR5' # Matches .env

mkdir -p $BACKUP_DIR

# Dump Database
docker exec $CONTAINER /usr/bin/mysqldump -u $DB_USER --password=$DB_PASS firefly | gzip > "$BACKUP_DIR/db_$TIMESTAMP.sql.gz"

# Retention Policy (Keep 30 Days)
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +30 -delete

echo "[OK] Backup completed: db_$TIMESTAMP.sql.gz"
