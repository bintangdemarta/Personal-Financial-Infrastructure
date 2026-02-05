# Operations Checklist

## Daily

- Verify containers: `docker compose ps`.
- Check DB health: `bash scripts/healthcheck.sh`.
- Review errors: `docker compose logs -f` (app/db) and `docker compose logs cron`.

## Weekly

- Validate backups: restore a recent backup to a temporary environment.
- Verify disk usage: `docker system df` and host disk space.
- Review security updates for host OS and Docker.

## Monthly

- Rotate secrets: `APP_KEY`, `DB_PASSWORD`, `STATIC_CRON_TOKEN` (and update `.env`).
- Audit accounts and rules in Firefly III.
- Confirm offsite backup integrity and access.
