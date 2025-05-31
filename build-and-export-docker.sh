#!/bin/bash

# Script per costruire ed esportare l'immagine Docker di cyberdrop-dl
# Autore: Script generato automaticamente
# Descrizione: Costruisce l'immagine Docker e la esporta come file .tar

set -e  # Esce se qualsiasi comando fallisce

# Colori per l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurazione
IMAGE_NAME="cyberdrop-dl"
TAR_FILE="cyberdrop-dl-docker-image.tar"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
VERSIONED_TAR_FILE="cyberdrop-dl-docker-image_${TIMESTAMP}.tar"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Cyberdrop-DL Docker Build & Export${NC}"
echo -e "${BLUE}===========================================${NC}"

# Controlla se Docker è installato e in esecuzione
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Errore: Docker non è installato o non è nel PATH${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}Errore: Docker non è in esecuzione${NC}"
    exit 1
fi

# Controlla se il Dockerfile esiste
if [ ! -f "Dockerfile" ]; then
    echo -e "${RED}Errore: Dockerfile non trovato nella directory corrente${NC}"
    exit 1
fi

echo -e "${YELLOW}Inizio costruzione dell'immagine Docker...${NC}"
echo -e "${YELLOW}Nome immagine: ${IMAGE_NAME}${NC}"

# Costruisce l'immagine Docker
if docker build -t "$IMAGE_NAME" .; then
    echo -e "${GREEN}✓ Immagine Docker costruita con successo!${NC}"
else
    echo -e "${RED}✗ Errore durante la costruzione dell'immagine Docker${NC}"
    exit 1
fi

echo
echo -e "${YELLOW}Inizio esportazione dell'immagine come file .tar...${NC}"

# Esporta l'immagine come file .tar
if docker save -o "$TAR_FILE" "$IMAGE_NAME"; then
    echo -e "${GREEN}✓ Immagine esportata con successo come ${TAR_FILE}${NC}"
    
    # Crea anche una versione con timestamp
    cp "$TAR_FILE" "$VERSIONED_TAR_FILE"
    echo -e "${GREEN}✓ Copia con timestamp creata: ${VERSIONED_TAR_FILE}${NC}"
    
    # Mostra informazioni sul file
    FILE_SIZE=$(du -h "$TAR_FILE" | cut -f1)
    echo -e "${BLUE}Dimensione file: ${FILE_SIZE}${NC}"
    
else
    echo -e "${RED}✗ Errore durante l'esportazione dell'immagine${NC}"
    exit 1
fi

echo
echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}  Processo completato con successo!${NC}"
echo -e "${GREEN}===========================================${NC}"
echo
echo -e "${BLUE}File generati:${NC}"
echo -e "  • ${TAR_FILE}"
echo -e "  • ${VERSIONED_TAR_FILE}"
echo
echo -e "${BLUE}Per importare l'immagine su un altro sistema:${NC}"
echo -e "  docker load -i ${TAR_FILE}"
echo
echo -e "${BLUE}Per eseguire il container:${NC}"
echo -e "  docker run -it --rm \\"
echo -e "    -v ./data:/app/downloads \\"
echo -e "    -v ./config:/app/config \\"
echo -e "    ${IMAGE_NAME} [argomenti-cyberdrop-dl]"
echo 