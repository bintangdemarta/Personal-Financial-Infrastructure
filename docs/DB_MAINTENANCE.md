# Database Maintenance

## Regular Checks

- Verify DB health: `docker compose ps`
- Review DB logs: `docker compose logs db`

## Backups

- Run `bash scripts/backup_db.sh` and verify size.

## Optimization

- MariaDB handles most optimizations automatically.
- If needed, run `OPTIMIZE TABLE` for large tables.
