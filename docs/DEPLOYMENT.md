# Deployment Guide

## Overview

This guide covers a standard production deployment using Docker Compose with Traefik.

## Prerequisites

- Docker Engine and Docker Compose installed
- Domain name pointing to your host
- Ports 80 and 443 open to the host

## Steps

1. Copy `.env.production` to `.env` and update values (APP_URL, secrets).
2. Start Traefik: `docker compose -f docker-compose.traefik.yml up -d`.
3. Start the app stack: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d`.
4. Wait for database health: `bash scripts/healthcheck.sh`.
5. Run permissions fix:
   - `docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload`
6. Access the UI via `https://your-domain` and create the admin user.

## Notes

- Ensure `APP_URL` matches your domain to avoid CORS issues.
- If you change domains, update `APP_URL` and restart the app container.
