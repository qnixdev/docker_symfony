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
	@echo "  clean               Stop & remove containers"
	@echo "  prune               Remove volumes & system of containers"
	@echo "  rmi                 Remove all images of containers"
	@echo "  log                 Follow log output"
	@echo "  composer-i          Install composer require"
	@echo "  composer-u          Update composer require"
	@echo "  yarn                Check yarn"
	@echo "  yarn-dev            Update yarn require for dev"
	@echo "  yarn-build          Update yarn require for prod"

init:
	-@mkdir data
	-@mkdir data/postgres
	@docker-compose -f docker/docker-compose.yaml up -d --build

up:
	@docker-compose -f docker/docker-compose.yaml up -d

down:
	@docker-compose -f docker/docker-compose.yaml stop

clean:
	-@docker rm $$(docker stop symfony-nginx-proxy)
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

log:
	@docker-compose -f docker/docker-compose.yaml logs -f

composer-i:
	@docker exec -u 1000 -it $(docker_php) composer i

composer-u:
	@docker exec -u 1000 -it $(docker_php) composer u

yarn:
	@docker exec -u 1000 -it $(docker_node) yarn

yarn-dev:
	@docker exec -u 1000 -it $(docker_node) yarn dev

yarn-build:
	@docker exec -u 1000 -it $(docker_node) yarn build

.PHONY: clean init help