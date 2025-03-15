build:
	APP_HOST=$(or ${APP_HOST},${APP_HOST}, "localhost") docker compose build

db_setup:
	APP_HOST=$(or ${APP_HOST},${APP_HOST}, "localhost") docker compose run --rm server bundle exec rails db:create db:migrate

up:
	APP_HOST=$(or ${APP_HOST},${APP_HOST}, "localhost") docker compose up

server_bash:
	APP_HOST=$(or ${APP_HOST},${APP_HOST}, "localhost") docker compose run --rm server bash

rails_console:
	APP_HOST=$(or ${APP_HOST},${APP_HOST}, "localhost") docker compose run --rm server bundle exec rails c

send_message:
	APP_HOST=$(or ${APP_HOST},${APP_HOST}, "localhost") docker compose run --rm server bundle exec rake karafka:producer:produce_sync
