# Restore Playbook

## Scenario

Use this playbook after data loss, corruption, or a failed upgrade.

## Steps

1. Confirm the latest good backup exists (local + offsite).
2. Stop services: `docker compose down`.
3. Restore the database:
   - `bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz`
4. Start services: `docker compose up -d`.
5. Validate:
   - `docker compose ps`
   - Log in and verify balances, rules, and recent transactions.
6. Record the incident in the ops log.

## Rollback

If restore fails, try a previous backup and repeat steps 2-5.
