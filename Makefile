docker_php = symfony-app
docker_node = symfony-node

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  init                Create db-lib & load/install containers"
	@echo "  up                  Start containers"
	@echo "  down                Stop containers"
	@echo "  log                 Follow log output"
	@echo "  clean               Stop & remove containers"
	@echo "  prune               Remove volumes & system of containers"
	@echo "  rmi                 Remove all images of containers"
	@echo "  composer-i          Install composer require"
	@echo "  composer-u          Update composer require"
	@echo "  yarn-dev            Update yarn require for dev"
	@echo "  yarn-build          Update yarn require for prod"
	@echo "  cache-clean         Clean symfony project cache"
	@echo "  enter-app           Login to application container"
	@echo "  enter-node          Login to node container"

init:
	-@mkdir data
	-@mkdir data/postgres
	@docker-compose --env-file ./docker/.env up -d --build

up:
	@docker-compose --env-file ./docker/.env up -d

down:
	@docker-compose --env-file ./docker/.env stop

log:
	@docker-compose --env-file ./docker/.env logs -f

clean:
	-@docker rm $$(docker stop symfony-proxy)
	-@docker rm $$(docker stop symfony-nginx)
	-@docker rm $$(docker stop symfony-app)
	-@docker rm $$(docker stop symfony-postgres)
	-@docker rm $$(docker stop symfony-redis)
	-@docker rm $$(docker stop symfony-node)

prune:
	@docker system prune -f
	@docker volume prune -f

rmi:
	@docker rmi $$(docker images -aq)

composer-i:
	@docker exec -u 1000 -it $(docker_php) composer i

composer-u:
	@docker exec -u 1000 -it $(docker_php) composer u

yarn-dev:
	@docker exec -u 1000 -it $(docker_node) yarn dev

yarn-build:
	@docker exec -u 1000 -it $(docker_node) yarn build

cache-clean:
	@rm -rf ./var/cache/

enter-app:
	@docker exec -it $(docker_php) bash

enter-node:
	@docker exec -it $(docker_node) sh

.PHONY: clean init help