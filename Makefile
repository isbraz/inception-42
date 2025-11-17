.PHONY: all build up down stop restart clean fclean re logs

all: build up

build:
	@echo "Building Docker images..."
	@docker compose -f srcs/docker-compose.yml build

up:
	@echo "Starting containers..."
	@docker compose -f srcs/docker-compose.yml up -d

down:
	@echo "Stopping and removing containers..."
	@docker compose -f srcs/docker-compose.yml down

stop:
	@echo "Stopping containers..."
	@docker compose -f srcs/docker-compose.yml stop

restart: down up

clean: down
	@echo "Cleaning up containers, networks, and images..."
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

fclean: clean
	@echo "Removing all data volumes..."
	@sudo rm -rf /home/ismael/data/wordpress/*
	@sudo rm -rf /home/ismael/data/mariadb/*
	@echo "Pruning Docker system..."
	@docker system prune -af --volumes

re: fclean all

logs:
	@docker compose -f srcs/docker-compose.yml logs -f
