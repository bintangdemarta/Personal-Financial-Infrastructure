# FIN-CORE-01 Runbook

## Important Note on Architecture Change

This repository has been modified to build the Firefly III application from source code rather than using the pre-built Docker image. See `MIGRATION_NOTE.md` for important information about this change and recommendations.

## Quick Start

```bash
# 1) Start services (this will now build from source)
docker compose up -d --build

# 2) Fix upload permissions
docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload

# 3) Open UI
# http://IP:APP_PORT
```

## User Journey

1. Log in and confirm accounts.
2. Add transactions and set rules.
3. Review balances weekly.

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
