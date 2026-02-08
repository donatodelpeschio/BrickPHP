# BrickPHP Management Tool

.PHONY: up down restart build install shell controller model migrate help

help:
	@echo "🧱 BrickPHP - Comandi disponibili:"
	@echo "  make install      Configurazione iniziale (composer, env, storage)"
	@echo "  make up           Avvia i container in background"
	@echo "  make down         Spegne i container"
	@echo "  make build        Ricostruisce le immagini Docker"
	@echo "  make shell        Entra nel terminale del container App"
	@echo "  make migrate      Esegue le migrazioni del database"
	@echo "  make controller name=User    Crea un nuovo Controller"
	@echo "  make model name=User         Crea un nuovo Model"

install:
	@chmod +x bin/setup.sh
	@./bin/setup.sh
	@# Ora che lo script ha creato il docker-compose.yml, possiamo usare Docker
	@echo "📦 Installazione dipendenze..."
	docker compose run --rm app composer install
	@echo "⚙️ Configurazione ambiente..."
	cp -n .env.example .env || true
	@echo "📂 Creazione cartelle storage e permessi..."
	docker exec -it brickphp_app mkdir -p storage/cache storage/logs storage/sessions
	docker exec -it brickphp_app chown -R www-data:www-data storage
	docker exec -it brickphp_app chmod -R 775 storage
	@echo "🗄️ Esecuzione migrazioni iniziali..."
	@make up # Avviamo i container per poter migrare
	sleep 5 # Aspettiamo che MySQL sia pronto
	docker exec -it brickphp_app php brick migrate

up:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose restart

build:
	docker-compose build

shell:
	docker exec -it brickphp_app bash

migrate:
	docker exec -it brickphp_app php brick migrate

controller:
	docker exec -it brickphp_app php brick make:controller $(name)

model:
	docker exec -it brickphp_app php brick make:model $(name)