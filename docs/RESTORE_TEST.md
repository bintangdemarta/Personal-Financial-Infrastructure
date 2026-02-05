# Backup Restore Test Checklist

## Goal

Validate that backups can be restored and the system is usable.

## Steps

1. Create a disposable environment (separate host or temporary compose project).
2. Bring up the stack: `docker compose up -d`.
3. Restore the latest backup: `bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz`.
4. Log in and verify:
   - Recent transactions are present.
   - Account balances match expectations.
   - Rules and categories are intact.
5. Record results in your ops log.
6. Tear down the test environment.

## Frequency

- Weekly or after major changes.
