# Bootstrap Checklist

## Pre-Flight

- Docker Engine installed
- Docker Compose installed
- `.env` created and validated

## Initial Deploy

1. `docker compose up -d`
2. `docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload`
3. Open UI and create admin
4. Configure accounts and rules
5. Run `bash scripts/backup_db.sh`

## Post-Deploy

- Verify health: `bash scripts/healthcheck.sh`
- Validate backup file exists in `backups/`
