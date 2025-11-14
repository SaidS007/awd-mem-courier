#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

BACKUP_DIR="backup_$(date +%Y-%m-%d_%H-%M-%S)"

echo -e "${BLUE}💾 Sauvegarde des données...${NC}"

# Créer le répertoire de sauvegarde
mkdir -p "$BACKUP_DIR"

# Sauvegarder les volumes Docker
echo -e "${BLUE}📦 Sauvegarde des volumes Docker...${NC}"

# Sauvegarder la base de données
if docker volume inspect mc_24_db-data &> /dev/null; then
    echo "Sauvegarde de la base de données..."
    docker run --rm -v mc_24_db-data:/source -v "$(pwd)/$BACKUP_DIR":/backup alpine \
        tar czf /backup/db-data.tar.gz -C /source ./
fi

# Sauvegarder les données Open-Capture
if docker volume inspect mc_24_opencapture_data &> /dev/null; then
    echo "Sauvegarde des données Open-Capture..."
    docker run --rm -v mc_24_opencapture_data:/source -v "$(pwd)/$BACKUP_DIR":/backup alpine \
        tar czf /backup/opencapture-data.tar.gz -C /source ./
fi

# Sauvegarder les autres volumes
for volume in mc_24_opencapture_docservers mc_24_opencapture_share mc_24_opencapture_venv; do
    if docker volume inspect "$volume" &> /dev/null; then
        echo "Sauvegarde de $volume..."
        docker run --rm -v "$volume":/source -v "$(pwd)/$BACKUP_DIR":/backup alpine \
            tar czf "/backup/$(echo $volume | sed 's/mc_24_//').tar.gz" -C /source ./
    fi
done

# Sauvegarder les fichiers locaux
echo -e "${BLUE}📁 Sauvegarde des fichiers locaux...${NC}"

if [ -d "custom" ]; then
    echo "Sauvegarde de custom/"
    tar czf "$BACKUP_DIR/custom.tar.gz" custom/
fi

if [ -d "docservers" ]; then
    echo "Sauvegarde de docservers/"
    tar czf "$BACKUP_DIR/docservers.tar.gz" docservers/
fi

if [ -d "librairies" ]; then
    echo "Sauvegarde de librairies/"
    tar czf "$BACKUP_DIR/librairies.tar.gz" librairies/
fi

# Créer un fichier d'information
echo "Sauvegarde créée le: $(date)" > "$BACKUP_DIR/backup-info.txt"
echo "Conteneurs:" >> "$BACKUP_DIR/backup-info.txt"
docker-compose -p mc_24 -f docker-compose.yml ps >> "$BACKUP_DIR/backup-info.txt"

echo -e "${GREEN}✅ Sauvegarde terminée dans $BACKUP_DIR/${NC}"
echo "Taille du backup: $(du -sh "$BACKUP_DIR" | cut -f1)"
