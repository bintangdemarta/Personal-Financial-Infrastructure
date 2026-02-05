# Common operations

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

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
