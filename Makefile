WP_DATA = /Users/chaverttermaat/data/wordpress
DB_DATA = /Users/chaverttermaat/data/mariadb

# 42 linux
# WP_DATA_42 = ~/goinfre/data/wordpress
# DB_DATA_42 = ~/goinfre/data/mariadb

all: up

up: build
	@mkdir -p $(DB_DATA)
	@mkdir -p $(WP_DATA)
	@chmod -R 755 $(DB_DATA)
	@chmod -R 755 $(WP_DATA)
	docker-compose -f ./src/docker-compose.yml up -d

down:
	docker-compose -f ./src/docker-compose.yml down

stop:
	docker-compose -f ./src/docker-compose.yml stop

run:
	docker-compose -f ./src/docker-compose.yml start

build:
	clear
	docker-compose -f ./src/docker-compose.yml build

nginx:
	@docker exec -it nginx zsh

mariadb:
	@docker exec -it mariadb zsh

wordpress:
	@docker exec -it wordpress zsh

clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true

re: clean up

.PHONY: all up down stop run build nginx mariadb wordpress clean re