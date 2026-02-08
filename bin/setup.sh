#!/bin/bash

# Colori per il feedback nel terminale
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Spostati nella root del progetto (una cartella sopra /bin)
cd "$(dirname "$0")/.."

echo "Eseguendo setup in: $(pwd)" # Debug per vedere se siamo nel posto giusto

if [ ! -f ".env.example" ]; then
    echo "❌ Errore: .env.example non trovato in $(pwd)!"
    ls -la # Mostra i file presenti per debug
    exit 1
fi

echo -e "${BLUE}🧱 BrickPHP: Configurazione Iniziale del Progetto${NC}"
echo "----------------------------------------------------"

# 1. Richiesta dati all'utente
read -p "Nome del progetto (es. tuoprogetto): " RAW_PROJECT_NAME
PROJECT_NAME=$(echo "$RAW_PROJECT_NAME" | tr '[:upper:]' '[:lower:]')
read -p "Porta Web (default 8080): " APP_PORT
APP_PORT=${APP_PORT:-8080}
read -p "Database Name: " DB_NAME
read -p "Database User: " DB_USER
read -p "Database Password: " DB_PASS

echo -e "\n🚀 Generazione file di configurazione..."

# 2. Generazione docker-compose.yml dal template
if [ -f "docker-compose.yml.template" ]; then
    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{APP_PORT}}/$APP_PORT/g" \
        -e "s/{{DB_NAME}}/$DB_NAME/g" \
        -e "s/{{DB_USER}}/$DB_USER/g" \
        -e "s/{{DB_PASS}}/$DB_PASS/g" \
        docker-compose.yml.template > docker-compose.yml
    echo -e "${GREEN}✅ docker-compose.yml creato.${NC}"
else
    echo -e "❌ Errore: docker-compose.yml.template non trovato!"
    exit 1
fi

# 3. Generazione file .env
if [ -f ".env.example" ]; then
    cp .env.example .env
    # Sostituzione delle variabili nel file .env appena creato
    # Usiamo un delimitatore diverso (|) perché il nome del DB o pass potrebbero avere slash
    sed -i "s|DB_DATABASE=.*|DB_DATABASE=$DB_NAME|" .env
    sed -i "s|DB_USERNAME=.*|DB_USERNAME=$DB_USER|" .env
    sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=$DB_PASS|" .env
    echo -e "${GREEN}✅ file .env creato e configurato.${NC}"
else
    echo -e "❌ Errore: .env.example non trovato!"
    exit 1
fi

# 4. Aggiornamento dinamico del Makefile per riflettere il nuovo PROJECT_NAME
sed -i "s/^PROJECT_NAME =.*/PROJECT_NAME = $PROJECT_NAME/" Makefile
echo -e "${GREEN}✅ Makefile aggiornato.${NC}"

echo -e "\n${GREEN}✨ Configurazione completata con successo!${NC}"