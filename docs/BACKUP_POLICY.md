# Backup Policy

## Goals

- Meet 3-2-1 standard (3 copies, 2 media, 1 offsite).
- Restore time objective (RTO): same day.
- Restore point objective (RPO): 24 hours.

## Retention

- Local: 30 days (handled by `scripts/backup_db.sh`).
- Offsite: 90 days (copy to encrypted storage).

## Storage

- Local: `./backups/` on host.
- Offsite: encrypted external drive or cloud storage.

## Encryption

- Use `gpg` or a password-protected archive before uploading offsite.

## Testing

- Perform restore tests weekly (see `docs/RESTORE_TEST.md`).
