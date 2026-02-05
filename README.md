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

## First Login Checklist (Chart of Accounts)

Create the following accounts as specified in Section 4.1:

Assets:
- Personal Liquid
- Project IO (Startup)
- Academic Fund
- Short-Term Reserve

Liabilities:
- Liabilities (Credit Cards, PayLater services)

## Automated Rules (Section 4.2)

- Rule A (Income Routing): If Description contains "Project", route 20% to Tax_Reserve and 80% to Project_IO_Liquid.
- Rule B (Subscription Management): If Description contains "DigitalOcean/AWS", tag as #Infrastructure and #Project_IO.

## Backup & Restore Quickstart

Backup:

```bash
bash scripts/backup_db.sh
```

Restore (example):

```bash
gzip -dc backups/db_YYYYMMDD_HHMM.sql.gz | docker exec -i firefly_db /usr/bin/mysql -u fin_admin --password=9xL#m2$vP8qZ!wR5 firefly
```

## Backup Retention & Offsite

- The backup script keeps 30 days locally.
- For 3-2-1 compliance, copy backups to a second device and an offsite location.

## Backup Cron Example (Host)

Run daily at 02:00 server time (Linux):

```bash
0 2 * * * /bin/bash /path/to/Managing\ Money\ System/scripts/backup_db.sh >> /var/log/fin_backup.log 2>&1
```

## Troubleshooting

- `firefly_db` not healthy: Wait 30-60 seconds, then re-check with `docker compose ps`. If still unhealthy, check logs: `docker compose logs db`.
- Web UI not loading: Confirm `APP_URL` matches the host IP/domain and port in `.env`, then restart: `docker compose restart app`.
- Permission errors uploading files: Re-run the permission fix command from Section 5.1.
- Cron not running: Ensure `STATIC_CRON_TOKEN` is set and matches the cron URL; verify cron logs: `docker compose logs cron`.

## Security Hardening Checklist

- Put Firefly III behind a reverse proxy (Traefik/Nginx) with HTTPS enabled.
- Restrict admin access by IP or VPN where possible.
- Rotate `APP_KEY`, `DB_PASSWORD`, and `STATIC_CRON_TOKEN` after initial setup.
- Keep the host OS and Docker engine up to date.
- Store backups offsite and restrict access to backup archives.

## Reverse Proxy (Traefik) Template

Use this as a starting point if you want HTTPS via Traefik. It exposes Firefly III through Traefik and keeps the app port internal.

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v3.0
    container_name: traefik
    restart: unless-stopped
    command:
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --certificatesresolvers.le.acme.tlschallenge=true
      - --certificatesresolvers.le.acme.email=you@example.com
      - --certificatesresolvers.le.acme.storage=/letsencrypt/acme.json
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - traefik_letsencrypt:/letsencrypt
    networks:
      - fin_net

  app:
    labels:
      - traefik.enable=true
      - traefik.http.routers.firefly.rule=Host(`fin.example.com`)
      - traefik.http.routers.firefly.entrypoints=websecure
      - traefik.http.routers.firefly.tls.certresolver=le
      - traefik.http.services.firefly.loadbalancer.server.port=8080

volumes:
  traefik_letsencrypt:

networks:
  fin_net:
    external: true
```

Note: In this setup, remove the host port mapping for `app` in `docker-compose.yml` and connect Traefik to the same `fin_net` network.

## Script Execution Notes

- On Linux, mark scripts executable once: `chmod +x scripts/backup_db.sh scripts/restore_db.sh scripts/healthcheck.sh`.
- On Windows, run via Git Bash/WSL using `bash scripts/backup_db.sh`, `bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz`, or `bash scripts/healthcheck.sh`.

## Production Compose

Use `docker-compose.prod.yml` to run behind Traefik and remove host port exposure.

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## Traefik Compose

Use `docker-compose.traefik.yml` to run Traefik on the same network.

```bash
docker compose -f docker-compose.traefik.yml up -d
```

## Disaster Recovery Checklist

- Confirm you have a recent backup in `backups/` and an offsite copy.
- Stop services: `docker compose down`.
- Restore the database using the latest backup: `bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz`.
- Start services: `docker compose up -d`.
- Validate: `docker compose ps`, then log in to confirm data integrity.

## Monitoring & Alerts

- Watch container health: `bash scripts/healthcheck.sh`.
- Check logs: `docker compose logs -f` (app and db) and `docker compose logs cron` (cron).
- Consider alerts via your host (Prometheus/Grafana, Healthchecks, or simple cron mail alerts).

## Log Rotation (Host)

If logs are growing, rotate them on the host:

- For Docker logs: configure `/etc/docker/daemon.json` with log rotation options.
- For cron logs (example): use `logrotate` for `/var/log/fin_backup.log`.

## Operations Reference

See `docs/OPERATIONS.md` for daily, weekly, and monthly ops checklists.

## Change Log

See `docs/CHANGELOG.md`.

## Default Branch

The default branch for this repository is `master`.

## Architecture Reference

See `docs/ARCHITECTURE.md` for the system diagram and component notes.

## Configuration Reference

See `docs/CONFIG.md` for `.env` documentation.

## Quick Runbook

See `docs/RUNBOOK_SHORT.md` for a minimal operations guide.

## Threat Model

See `docs/THREAT_MODEL.md` for lightweight threat analysis and mitigations.

## Restore Test

See `docs/RESTORE_TEST.md` for backup restore validation.

## Deployment Guide

See `docs/DEPLOYMENT.md` for production deployment steps.

## Upgrade Guide

See `docs/UPGRADES.md` for safe upgrade steps.

## Backup Policy

See `docs/BACKUP_POLICY.md` for retention and encryption guidance.

## Access Control

See `docs/ACCESS_CONTROL.md` for access policy and reviews.

## Restore Playbook

See `docs/RESTORE_PLAYBOOK.md` for incident recovery steps.

## Ops Log

See `docs/OPS_LOG.md` for operational record keeping.

## Style Guide

See `docs/STYLE_GUIDE.md` for documentation conventions.

## Decisions Log

See `docs/DECISIONS.md` for architecture decisions.

## Onboarding

See `docs/ONBOARDING.md` for new admin setup.

## Incident Template

See `docs/INCIDENT_TEMPLATE.md` for incident writeups.

## Audit Checklist

See `docs/AUDIT.md` for review steps.

## Review Schedule

See `docs/REVIEW_SCHEDULE.md` for recurring reviews.

## Bootstrap Checklist

See `docs/BOOTSTRAP_CHECKLIST.md` for startup validation.

## Decommission

See `docs/DECOMMISSION.md` for end-of-life procedures.

## Glossary

See `docs/GLOSSARY.md` for common terms.

## FAQ

See `docs/FAQ.md` for common questions.

## Contributing

See `CONTRIBUTING.md` for contribution guidelines.

## Code of Conduct

See `CODE_OF_CONDUCT.md` for behavior expectations.

## Troubleshooting Guide

See `docs/TROUBLESHOOTING.md` for diagnostics and fixes.

## Ops FAQ

See `docs/FAQ_OPS.md` for operations-specific questions.

## Maintenance Guide

See `docs/MAINTENANCE.md` for periodic tasks.

## Networking Guide

See `docs/NETWORKING.md` for ports and DNS.

## Database Maintenance

See `docs/DB_MAINTENANCE.md` for DB checks.
