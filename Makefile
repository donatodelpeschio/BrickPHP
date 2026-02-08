# ==============================================================================
# BrickPHP Framework - Makefile
# ==============================================================================

# Variabili iniziali (verranno sovrascritte dallo script bin/setup.sh)
PROJECT_NAME = brickphp
APP_CONTAINER = $(PROJECT_NAME)_app

.PHONY: install up down restart shell migrate

# Target principale eseguito da Composer dopo il create-project
install:
	@chmod +x bin/setup.sh
	@./bin/setup.sh
	@echo "🚀 Avvio dei container Docker..."
	docker compose up -d
	@echo "⏳ Attesa inizializzazione servizi (20s)..."
	@sleep 20
	@echo "📦 Installazione dipendenze via Composer..."
	@# Usiamo l'ID dinamico del container per evitare errori di nome
	docker exec -it $$(docker compose ps -q app) composer install
	@echo "📂 Configurazione cartelle storage e permessi..."
	@# Creazione ricorsiva e assegnazione al proprietario www-data (utente PHP)
	docker exec -it $$(docker compose ps -q app) mkdir -p storage/cache storage/logs storage/sessions
	docker exec -it $$(docker compose ps -q app) chown -R www-data:www-data storage
	docker exec -it $$(docker compose ps -q app) chmod -R 775 storage
	@echo "🗄️ Esecuzione migrazioni database..."
	docker exec -it $$(docker compose ps -q app) php brick migrate
	@echo ""
	@echo "===================================================="
	@echo "✨ BrickPHP installato con successo!"
	@echo "🌐 URL: http://localhost:8080"
	@echo "===================================================="

# Avvia i container esistenti
up:
	docker compose up -d

# Ferma i container
down:
	docker compose down

# Riavvia tutto
restart:
	docker compose restart

# Entra nel terminale del container PHP
shell:
	docker exec -it $$(docker compose ps -q app) sh

# Esegue manualmente le migrazioni
migrate:
	docker exec -it $$(docker compose ps -q app) php brick migrate