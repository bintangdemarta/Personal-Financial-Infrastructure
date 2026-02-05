# Rollback Procedures

## When to Roll Back

- Failed upgrade or migration.
- Data inconsistency detected.

## Steps

1. Stop services: `docker compose down`.
2. Restore latest backup.
3. Start services: `docker compose up -d`.
4. Validate data and health.
