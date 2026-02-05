# Upgrade Guide

## Overview

This guide explains how to upgrade Firefly III and the database safely.

## Steps

1. Create a fresh backup: `bash scripts/backup_db.sh`.
2. Pull latest images: `docker compose pull`.
3. Restart services: `docker compose up -d`.
4. Watch logs for migrations: `docker compose logs -f app`.
5. Verify health: `bash scripts/healthcheck.sh`.
6. Log in and validate balances and recent transactions.

## Notes

- Avoid skipping major versions if release notes advise incremental upgrades.
- Keep a rollback plan: stop services and restore backup if needed.
