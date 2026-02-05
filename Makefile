# Common operations

up:
	docker compose up -d

up-build:
	docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

build:
	bash scripts/build.sh

build-force:
	docker compose build --no-cache

backup:
	bash scripts/backup_db.sh

restore:
	bash scripts/restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz

health:
	bash scripts/healthcheck.sh

prod-up:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

traefik-up:
	docker compose -f docker-compose.traefik.yml up -d

# Monitoring stack
monitoring-up:
	docker compose -f docker-compose.monitoring.yml up -d

monitoring-down:
	docker compose -f docker-compose.monitoring.yml down

# Logging stack
logging-up:
	docker compose -f docker-compose.logging.yml up -d

logging-down:
	docker compose -f docker-compose.logging.yml down

# Security scanning
security-scan:
	docker compose -f docker-compose.security.yml run app-scanner

# Clean up everything
clean:
	docker compose down -v
	docker compose -f docker-compose.monitoring.yml down -v
	docker compose -f docker-compose.logging.yml down -v
	docker system prune -f

# Full stack (app + monitoring + logging)
full-up:
	docker compose up -d --build
	docker compose -f docker-compose.monitoring.yml up -d
	docker compose -f docker-compose.logging.yml up -d
