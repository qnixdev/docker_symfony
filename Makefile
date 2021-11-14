docker_php = symfony-app

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  init                Create libs & containers"
	@echo "  up                  Up containers"
	@echo "  down                Stop containers"
	@echo "  log                 Watch logs"
	@echo "  enter               Login to app container"
	@echo "  clean               Stop & remove project containers"
	@echo "  prune               Remove volumes, layers & stopped containers"
	@echo "  rmi                 Remove all containers"
	@echo "  cache-clean         Clean symfony project cache"
	@echo "  data-clean          Clean project data"
	@echo "  composer-i          Install composer require"
	@echo "  composer-u          Update composer require"

init:
	-@mkdir -p .docker/data/postgres .docker/data/rabbitmq
	@docker-compose -f .docker/docker-compose.yaml --env-file .docker/.env up -d --build

up:
	@docker-compose -f .docker/docker-compose.yaml --env-file .docker/.env up -d

down:
	@docker-compose -f .docker/docker-compose.yaml --env-file .docker/.env stop

log:
	@docker-compose -f .docker/docker-compose.yaml --env-file .docker/.env logs -f

enter:
	@docker exec -it $(docker_php) sh

clean:
	-@docker rm $$(docker stop symfony-proxy)
	-@docker rm $$(docker stop symfony-nginx)
	-@docker rm $$(docker stop symfony-app)
	-@docker rm $$(docker stop symfony-postgres)
	-@docker rm $$(docker stop symfony-rabbitmq)

prune:
	@docker system prune -f
	@docker volume prune -f

rmi:
	@docker rmi $$(docker images -aq)

cache-clean:
	@rm -rf var/cache/

data-clean:
	@rm -rf .docker/data

composer-i:
	@docker exec -it -u 1000:1000 $(docker_php) composer i

composer-u:
	@docker exec -it -u 1000:1000 $(docker_php) composer u

.PHONY: clean init help