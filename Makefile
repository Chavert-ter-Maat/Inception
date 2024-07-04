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

re: down clean all
	@echo "$(COLOR_GREEN)🔄 Docker-compose rebuilt and running$(COLOR_RESET)"

maria:
	@docker exec -it mariadb bash;

nginx:
	@docker exec -it nginx bash;

wordpress:
	@docker exec -it wordpress bash;

clean:
	@docker ps -qa | xargs docker stop || true
	@docker ps -qa | xargs docker rm -f || true
	@docker images -q | xargs docker rmi -f || true
	@docker volume ls -q | xargs docker volume rm || true
	@rm -rf ~/data/mariadb ~/data/wordpress
	@echo "$(COLOR_GREEN)🗑️ Cleaned up Docker containers, images, volumes, and directories$(COLOR_RESET)"


.PHONY: all re down clean