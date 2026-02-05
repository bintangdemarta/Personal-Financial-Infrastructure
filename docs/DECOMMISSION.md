# Decommission Checklist

## Goal

Safely shut down the system while preserving data.

## Steps

1. Create a final backup: `bash scripts/backup_db.sh`.
2. Export key reports if needed.
3. Stop services: `docker compose down`.
4. Archive backups and configs securely.
5. Remove containers/volumes only if data retention requirements are met.
