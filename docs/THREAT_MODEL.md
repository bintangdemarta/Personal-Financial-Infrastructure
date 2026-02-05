# Threat Model (Lightweight)

## Assets

- Financial transaction data
- Credentials and API tokens
- Backups

## Threats

- Unauthorized access to the web UI
- Credential leakage via `.env`
- Exposed database port
- Compromised host or Docker daemon
- Backup leakage

## Mitigations

- Enforce HTTPS and restrict access (VPN/IP allowlist).
- Keep `.env` out of git; rotate secrets regularly.
- Do not publish DB ports; keep DB on internal network only.
- Keep host OS and Docker patched.
- Encrypt offsite backups.

## Incident Response

- Rotate credentials (`APP_KEY`, DB password, cron token).
- Revoke any leaked tokens.
- Restore from last known-good backup.
- Audit logs for access anomalies.
