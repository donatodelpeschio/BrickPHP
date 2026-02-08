#!/bin/bash

# Colori per il feedback nel terminale
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Spostati nella root del progetto (una cartella sopra la cartella dove si trova questo script)
cd "$(dirname "$0")/.."

echo -e "${BLUE}🧱 BrickPHP: Configurazione Iniziale del Progetto${NC}"
echo "----------------------------------------------------"

# Controllo se i template esistono prima di iniziare
if [ ! -f ".env.example" ] || [ ! -f "docker-compose.yml.template" ]; then
    echo -e "${RED}❌ Errore: File template (.env.example o docker-compose.yml.template) non trovati!${NC}"
    exit 1
fi

# 1. Richiesta dati all'utente
read -p "Nome del progetto (es. tanklog): " INPUT_NAME
PROJECT_NAME=$(echo "$INPUT_NAME" | tr '[:upper:]' '[:lower:]' | tr -d ' ') # Rimuove anche eventuali spazi

read -p "Porta Web (default 8080): " APP_PORT
APP_PORT=${APP_PORT:-8080}

read -p "Database Name: " DB_NAME
read -p "Database User: " DB_USER
read -sp "Database Password: " DB_PASS # -sp nasconde la password mentre la scrivi
echo -e "\n"

echo -e "🚀 Generazione file di configurazione..."

# 2. Generazione docker-compose.yml
# Usiamo un delimitatore diverso per sed (@) per evitare conflitti con caratteri speciali
sed -e "s@{{PROJECT_NAME}}@$PROJECT_NAME@g" \
    -e "s@{{APP_PORT}}@$APP_PORT@g" \
    -e "s@{{DB_NAME}}@$DB_NAME@g" \
    -e "s@{{DB_USER}}@$DB_USER@g" \
    -e "s@{{DB_PASS}}@$DB_PASS@g" \
    docker-compose.yml.template > docker-compose.yml
echo -e "${GREEN}✅ docker-compose.yml creato.${NC}"

# 3. Generazione file .env
cp .env.example .env
# Compatibilità macOS/Linux per sed -i
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|DB_DATABASE=.*|DB_DATABASE=$DB_NAME|" .env
    sed -i '' "s|DB_USERNAME=.*|DB_USERNAME=$DB_USER|" .env
    sed -i '' "s|DB_PASSWORD=.*|DB_PASSWORD=$DB_PASS|" .env
else
    sed -i "s|DB_DATABASE=.*|DB_DATABASE=$DB_NAME|" .env
    sed -i "s|DB_USERNAME=.*|DB_USERNAME=$DB_USER|" .env
    sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=$DB_PASS|" .env
fi
echo -e "${GREEN}✅ file .env creato e configurato.${NC}"

# 4. Aggiornamento dinamico del Makefile
if [ -f "Makefile" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^PROJECT_NAME =.*/PROJECT_NAME = $PROJECT_NAME/" Makefile
    else
        sed -i "s/^PROJECT_NAME =.*/PROJECT_NAME = $PROJECT_NAME/" Makefile
    fi
    echo -e "${GREEN}✅ Makefile aggiornato.${NC}"
fi

echo -e "\n${GREEN}✨ Configurazione completata con successo!${NC}"
echo -e "Ora puoi eseguire: ${BLUE}make up${NC}\n"