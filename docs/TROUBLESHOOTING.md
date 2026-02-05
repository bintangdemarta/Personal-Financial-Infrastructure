# Troubleshooting Guide

## Common Issues

### Database not healthy

- Wait 30-60 seconds and re-check:
  - `docker compose ps`
- Check logs:
  - `docker compose logs db`

### Web UI not loading

- Confirm `APP_URL` in `.env` matches your domain/IP.
- Restart app:
  - `docker compose restart app`

### Cron not running

- Confirm `STATIC_CRON_TOKEN` is set.
- Check cron logs:
  - `docker compose logs cron`

### Permission errors on uploads

- Re-run permission fix:
  - `docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload`

## Diagnostics

- Container status: `docker compose ps`
- App logs: `docker compose logs -f app`
- DB logs: `docker compose logs -f db`
- Disk usage: `docker system df`
