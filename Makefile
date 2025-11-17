.PHONY: all build up down stop restart clean fclean re logs

all: build up

build:
	@docker compose -f srcs/docker-compose.yml build

up:
	@mkdir -p /home/ismael/data/mariadb
	@mkdir -p /home/ismael/data/wordpress
	@docker compose -f srcs/docker-compose.yml down 2>/dev/null || true
	@sleep 1
	@docker compose -f srcs/docker-compose.yml up -d

down:
	@docker compose -f srcs/docker-compose.yml down 2>/dev/null || true

stop:
	@docker compose -f srcs/docker-compose.yml stop

restart: down
	@sleep 2
	@$(MAKE) up

clean:
	@docker compose -f srcs/docker-compose.yml down -v --remove-orphans 2>/dev/null || true
	@docker rm -f nginx mariadb wordpress 2>/dev/null || true
	@docker rmi -f nginx mariadb wordpress 2>/dev/null || true
	@docker volume rm -f srcs_mariadb_data srcs_wordpress_data 2>/dev/null || true

fclean: clean
	@sudo rm -rf /home/ismael/data/wordpress/*
	@sudo rm -rf /home/ismael/data/mariadb/*
	@docker system prune -af --volumes 2>/dev/null || true

re: fclean all

logs:
	@docker compose -f srcs/docker-compose.yml logs -f
