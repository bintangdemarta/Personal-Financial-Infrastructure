# FIN-CORE-01 Runbook

## First-Run Steps (from PRD)

1. Infrastructure: Install Docker & Compose on the host.
2. Configuration: Create .env file with the contents from Section 3.2.
3. Deployment: Run docker-compose up -d.
4. Permission Fix: Execute the chown command from Section 5.1.
5. Verification: Access web UI (http://IP:8080), create the first Admin User.
6. Initialization: Set up the "Asset Accounts" (Section 4.1).
7. Backup Test: Run bash scripts/backup_db.sh manually to confirm it works.

## Permission Fix Command (Section 5.1)

```bash
docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload
```

## Optional Verification

```bash
docker compose ps
```

Note: Wait until `firefly_db` reports `healthy` before proceeding.

## Backup & Restore Quickstart

Backup:

```bash
bash scripts/backup_db.sh
```

Restore (example):

```bash
gzip -dc backups/db_YYYYMMDD_HHMM.sql.gz | docker exec -i firefly_db /usr/bin/mysql -u fin_admin --password=9xL#m2$vP8qZ!wR5 firefly
```

## Troubleshooting (Quick)

- DB not healthy: `docker compose ps`, then `docker compose logs db`.
- Web UI not loading: verify `APP_URL`, then `docker compose restart app`.
- Permission errors: re-run the chown command above.

## Docs Index

See `docs/INDEX.md` for the full documentation catalog.

## Default Branch

The default branch for this repository is `master`.
