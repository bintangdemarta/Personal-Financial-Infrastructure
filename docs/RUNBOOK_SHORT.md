# Runbook (Short)

## Quick Start

1. `docker compose up -d`
2. `docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload`
3. Open `http://IP:8080`, create admin user.

## Backup

- `bash scripts/backup_db.sh`

## Restore

- `bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz`

## Health

- `bash scripts/healthcheck.sh`
