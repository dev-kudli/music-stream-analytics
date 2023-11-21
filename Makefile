COMPOSE_BASE := docker compose

start:
	$(COMPOSE_BASE) up -d

down:
	$(COMPOSE_BASE) down

clean:
	$(COMPOSE_BASE) down -v