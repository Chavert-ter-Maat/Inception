NAME = inception

# Define color codes
COLOR_RESET=\033[0m
COLOR_GREEN=\033[32m

all:
	@mkdir -p ~/data/mariadb; echo "$(COLOR_GREEN)✅ Created directory ~/data/mariadb$(COLOR_RESET)"
	@mkdir -p ~/data/wordpress; echo "$(COLOR_GREEN)✅ Created directory ~/data/wordpress$(COLOR_RESET)"
	@docker-compose -f src/docker-compose.yml up --build -d;
	@echo "$(COLOR_GREEN)🌟 Everything up and running ...$(COLOR_RESET)"

down:
	@docker-compose -f src/docker-compose.yml down; echo "$(COLOR_GREEN)🛑 Docker-compose down$(COLOR_RESET)"

re:
	@docker-compose -f src/docker-compose.yml up --build -d; echo "$(COLOR_GREEN)🔄 Docker-compose rebuilt and running$(COLOR_RESET)"

maria:
	@docker exec -it mariadb bash; echo "$(COLOR_GREEN)🐬 Entered mariadb container$(COLOR_RESET)"

clean:
	@docker stop $$(docker ps -qa); echo "$(COLOR_GREEN)🛑 Stopped all running containers$(COLOR_RESET)"; \
	docker rm $$(docker ps -qa); echo "$(COLOR_GREEN)🗑️ Removed all containers$(COLOR_RESET)"; \
	docker rmi -f $$(docker images -q); echo "$(COLOR_GREEN)🗑️ Removed all images$(COLOR_RESET)"; \
	docker volume rm $$(docker volume ls -q); echo "$(COLOR_GREEN)🗑️ Removed all volumes$(COLOR_RESET)"; \
	rm -rf ~/data/mariadb ~/data/wordpress; echo "$(COLOR_GREEN)🗑️ Deleted directories ~/data/mariadb and ~/data/wordpress$(COLOR_RESET)"

.PHONY: all re down clean