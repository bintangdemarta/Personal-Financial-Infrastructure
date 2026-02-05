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
	bash backup_db.sh

restore:
	bash restore_db.sh backups/db_YYYYMMDD_HHMM.sql.gz
