docker_php = symfony-app

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  init                Create db-lib & load/install containers"
	@echo "  up                  Start containers"
	@echo "  down                Stop containers"
	@echo "  log                 Follow log output"
	@echo "  enter               Login to application container"
	@echo "  clean               Stop & remove containers"
	@echo "  prune               Remove volumes & system of containers"
	@echo "  rmi                 Remove all images of containers"
	@echo "  cache-clean         Clean symfony project cache"
	@echo "  composer-i          Install composer require"
	@echo "  composer-u          Update composer require"

init:
	-@mkdir ./docker/data
	-@mkdir ./docker/data/postgres
	@docker-compose -f ./docker/docker-compose.yaml --env-file ./docker/.env up -d --build

up:
	@docker-compose -f ./docker/docker-compose.yaml --env-file ./docker/.env up -d

down:
	@docker-compose -f ./docker/docker-compose.yaml --env-file ./docker/.env stop

log:
	@docker-compose -f ./docker/docker-compose.yaml --env-file ./docker/.env logs -f

enter:
	@docker exec -it $(docker_php) sh

clean:
	-@docker rm $$(docker stop symfony-proxy)
	-@docker rm $$(docker stop symfony-nginx)
	-@docker rm $$(docker stop symfony-app)
	-@docker rm $$(docker stop symfony-postgres)

prune:
	@docker system prune -f
	@docker volume prune -f

rmi:
	@docker rmi $$(docker images -aq)

cache-clean:
	@rm -rf ./app/var/cache/

composer-i:
	@docker exec -u 1000 -it -u 1000:1000 $(docker_php) composer i

composer-u:
	@docker exec -u 1000 -it -u 1000:1000 $(docker_php) composer u

.PHONY: clean init help