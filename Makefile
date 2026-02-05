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
	docker compose ps --format "table {{.Name}}\t{{.State}}"
	@powershell -Command "$$s=''; while ($$true) { $$s=(docker compose ps --format '{{.Name}} {{.State}}') -join ""; if ($$s -match 'firefly_db.*healthy') { break } Start-Sleep -Seconds 2 }"
