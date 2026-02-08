# ==============================================================================
# BrickPHP Framework - Makefile
# ==============================================================================

# Recupera il nome del progetto e la porta dal file .env (se esiste)
PROJECT_NAME = $(shell grep APP_NAME .env | cut -d '=' -f2 || echo "brickphp")
APP_PORT = $(shell grep APP_PORT .env | cut -d '=' -f2 || echo "8080")
APP_SERVICE = app

.PHONY: install up down restart shell migrate logs

install:
	@chmod +x bin/setup.sh
	@./bin/setup.sh
	@echo "🚀 Avvio dei container Docker..."
	docker compose up -d --build
	@echo "⏳ Attesa inizializzazione database (15s)..."
	@sleep 15
	@echo "📦 Installazione dipendenze via Composer..."
	docker compose exec -w /var/www/html $(APP_SERVICE) composer install
	@echo "📂 Configurazione cartelle storage e permessi..."
	docker compose exec -w /var/www/html $(APP_SERVICE) mkdir -p storage/cache storage/logs storage/sessions
	docker compose exec -w /var/www/html $(APP_SERVICE) chown -R www-data:www-data storage
	docker compose exec -w /var/www/html $(APP_SERVICE) chmod -R 775 storage
	@echo "🗄️ Esecuzione migrazioni database..."
	docker compose exec -w /var/www/html $(APP_SERVICE) php brick migrate
	@echo ""
	@echo "===================================================="
	@echo "✨ BrickPHP installato con successo!"
	@echo "🌐 URL: http://localhost:$(APP_PORT)"
	@echo "🛠️  Shell: make shell"
	@echo "📝 Crea Controller: php brick make:controller Nome"
	@echo "===================================================="

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

shell:
	docker compose exec -it -w /var/www/html $(APP_SERVICE) sh

migrate:
	docker compose exec -it -w /var/www/html $(APP_SERVICE) php brick migrate

logs:
	docker compose logs -f $(APP_SERVICE)