# Key Commands

- Start: `docker compose up -d`
- Stop: `docker compose down`
- Logs: `docker compose logs -f`
- Health: `bash scripts/healthcheck.sh`
- Backup: `bash scripts/backup_db.sh`
- Restore: `bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz`
