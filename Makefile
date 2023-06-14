up:
	docker compose up --remove-orphans --build

down:
	docker compose down

db:
	docker compose exec db psql -U postgres

db-bash:
	docker compose exec db bash

db-reset:
	docker compose exec db psql -U postgres -c "truncate targets"
	docker compose exec db psql -U postgres -c "truncate cron.job"
	docker compose exec db psql -U postgres -c "truncate cron.job_run_details"

db-seed:
	docker compose exec db psql -U postgres -c "insert into targets (name,url) values ('test invalid ssl', 'https://expired.badssl.com/')"
