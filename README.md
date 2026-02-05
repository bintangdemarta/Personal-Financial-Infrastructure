# FIN-CORE-01 Runbook

## Important Note on Architecture Change

This repository has been modified to build the Firefly III application from source code rather than using the pre-built Docker image. See `MIGRATION_NOTE.md` for important information about this change and recommendations.

## Enhanced Docker Build Process

The Docker build process has been significantly improved with:

- **Multi-stage builds** for smaller, more secure images
- **Resource limits** to prevent container resource exhaustion
- **Custom MariaDB configuration** for better performance
- **Health checks** to monitor service status
- **Build scripts** for easier deployment
- **Improved volume management** for persistent data

## Quick Start

```bash
# 1) Build and start services (this will build from source)
docker compose up -d --build

# Alternative: Use the build script
bash scripts/build.sh
docker compose up -d

# 2) Fix upload permissions
docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload

# 3) Open UI
# http://IP:APP_PORT
```

## Development vs Production

- For development: Use `docker-compose.yml` (current configuration)
- For production: Use `docker-compose.prod.yml` with resource optimizations

## Build Scripts

Two build scripts are provided:
- `scripts/build.sh` - For Unix/Linux/macOS systems
- `scripts/build.bat` - For Windows systems

## Advanced Configuration

- Custom MariaDB configuration is available in `mariadb.conf`
- Docker build context and file are explicitly defined in `docker-compose.yml`
- Resource limits can be adjusted in the compose files

## Monitoring and Observability

The system includes a comprehensive monitoring stack:

- **Prometheus**: For metrics collection and alerting
- **Grafana**: For visualization and dashboards
- **Node Exporter**: For system-level metrics

To start the monitoring stack:
```bash
make monitoring-up
# Or directly:
docker compose -f docker-compose.monitoring.yml up -d
```

Access Grafana at `http://localhost:3000` (default login: admin/admin123 - change this in production!)

## Centralized Logging

The system includes an ELK stack for centralized logging:

- **Elasticsearch**: For log storage and indexing
- **Logstash**: For log processing and transformation
- **Kibana**: For log visualization and analysis

To start the logging stack:
```bash
make logging-up
# Or directly:
docker compose -f docker-compose.logging.yml up -d
```

Access Kibana at `http://localhost:5601`

## Security Features

- **Security Headers**: Configured in `security/headers.conf`
- **Vulnerability Scanning**: Using Trivy for container and application scanning
- **Resource Limits**: Preventing resource exhaustion attacks

To run a security scan:
```bash
make security-scan
```

## Full Stack Deployment

To run the complete stack with monitoring and logging:
```bash
make full-up
```

This starts the application, monitoring, and logging stacks together.

## User Journey

1. Log in and confirm accounts.
2. Add transactions and set rules.
3. Review balances weekly.

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

## Backup & Restore Quickstart

Backup:

```bash
bash scripts/backup_db.sh
```

Restore (example):

```bash
gzip -dc backups/db_YYYYMMDD_HHMM.sql.gz | docker exec -i firefly_db /usr/bin/mysql -u fin_admin --password=9xL#m2$vP8qZ!wR5 firefly
```

## Troubleshooting (Quick)

- DB not healthy: `docker compose ps`, then `docker compose logs db`.
- Web UI not loading: verify `APP_URL`, then `docker compose restart app`.
- Permission errors: re-run the chown command above.

## Docs Index

See `docs/INDEX.md` for the full documentation catalog.

## Default Branch

The default branch for this repository is `master`.
