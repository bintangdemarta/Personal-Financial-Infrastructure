# Ops FAQ

## How do I verify backups?

Run `bash scripts/restore_db.sh` in a temporary environment and validate data.

## How do I rotate secrets?

Update `.env` and restart containers.

## How do I check health?

Run `bash scripts/healthcheck.sh`.
