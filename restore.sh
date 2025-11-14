#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Usage: $0 <dossier_de_sauvegarde>${NC}"
    echo "Exemple: $0 backup_2024-01-15_10-30-00"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}❌ Le dossier de sauvegarde '$BACKUP_DIR' n'existe pas${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Restauration depuis $BACKUP_DIR...${NC}"

# Arrêter les services
echo "Arrêt des services..."
docker-compose -p mc_24 -f docker-compose.yml down

# Restaurer les volumes Docker
echo -e "${BLUE}📦 Restauration des volumes Docker...${NC}"

if [ -f "$BACKUP_DIR/db-data.tar.gz" ]; then
    echo "Restauration de la base de données..."
    docker run --rm -v mc_24_db-data:/target -v "$(pwd)/$BACKUP_DIR":/backup alpine \
        sh -c "rm -rf /target/* && tar xzf /backup/db-data.tar.gz -C /target"
fi

if [ -f "$BACKUP_DIR/opencapture-data.tar.gz" ]; then
    echo "Restauration des données Open-Capture..."
    docker run --rm -v mc_24_opencapture_data:/target -v "$(pwd)/$BACKUP_DIR":/backup alpine \
        sh -c "rm -rf /target/* && tar xzf /backup/opencapture-data.tar.gz -C /target"
fi

# Restaurer les autres volumes
for volume_file in "$BACKUP_DIR"/*.tar.gz; do
    if [ -f "$volume_file" ]; then
        volume_name=$(basename "$volume_file" .tar.gz)
        case $volume_name in
            opencapture-docservers)
                docker_volume="mc_24_opencapture_docservers"
                ;;
            opencapture-share)
                docker_volume="mc_24_opencapture_share"
                ;;
            opencapture-venv)
                docker_volume="mc_24_opencapture_venv"
                ;;
            *)
                continue
                ;;
        esac
        
        if docker volume inspect "$docker_volume" &> /dev/null; then
            echo "Restauration de $docker_volume..."
            docker run --rm -v "$docker_volume":/target -v "$(pwd)/$BACKUP_DIR":/backup alpine \
                sh -c "rm -rf /target/* && tar xzf /backup/$(basename $volume_file) -C /target"
        fi
    fi
done

# Restaurer les fichiers locaux
echo -e "${BLUE}📁 Restauration des fichiers locaux...${NC}"

if [ -f "$BACKUP_DIR/custom.tar.gz" ]; then
    echo "Restauration de custom/"
    rm -rf custom
    tar xzf "$BACKUP_DIR/custom.tar.gz"
fi

if [ -f "$BACKUP_DIR/docservers.tar.gz" ]; then
    echo "Restauration de docservers/"
    rm -rf docservers
    tar xzf "$BACKUP_DIR/docservers.tar.gz"
fi

if [ -f "$BACKUP_DIR/librairies.tar.gz" ]; then
    echo "Restauration de librairies/"
    rm -rf librairies
    tar xzf "$BACKUP_DIR/librairies.tar.gz"
fi

# Redémarrer les services
echo "Redémarrage des services..."
docker-compose -p mc_24 -f docker-compose.yml up -d

echo -e "${GREEN}✅ Restauration terminée!${NC}"
echo "Les services redémarrent..."
