# Configuration Reference

This document summarizes `.env` configuration options used by FIN-CORE-01.

## Instance Identity

- `APP_URL`: Public base URL for Firefly III (IP or domain).
- `APP_KEY`: 32+ character random string.
- `APP_ENV`: `production` or `local`.
- `APP_DEBUG`: `false` for production.

## Localization

- `SITE_OWNER`: Contact email.
- `TZ`: Timezone (e.g., `Asia/Jakarta`).
- `DEFAULT_LANGUAGE`: UI language (e.g., `en_US`).
- `DEFAULT_LOCALE`: Locale (e.g., `id_ID`).

## Database

- `DB_CONNECTION`: `mysql`.
- `DB_HOST`: `db`.
- `DB_PORT`: `3306`.
- `DB_DATABASE`: Database name.
- `DB_USERNAME`: DB user.
- `DB_PASSWORD`: DB password.

## Proxy & Security

- `TRUSTED_PROXIES`: Typically `**` for reverse proxy.
- `APP_FORCE_ROOT_URL`: Set to `${APP_URL}` when behind proxy.

## Automation

- `STATIC_CRON_TOKEN`: Token used by cron sidecar.

## Optional Docker Secrets

- `DB_PASSWORD_FILE`
- `APP_KEY_FILE`
- `STATIC_CRON_TOKEN_FILE`

Refer to `.env.example` for the exact template.
