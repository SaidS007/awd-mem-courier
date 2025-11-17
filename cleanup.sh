#!/bin/bash

# Couleurs
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}🧹 Nettoyage du système...${NC}"

# Supprimer les conteneurs arrêtés
echo "Suppression des conteneurs arrêtés..."
docker-compose -p mc_24 -f docker-compose.yml down

# Supprimer les images non utilisées
echo "Nettoyage des images Docker..."
docker image prune -f

# Supprimer les réseaux non utilisés
echo "Nettoyage des réseaux Docker..."
docker network prune -f

# Nettoyer le cache système
echo "Nettoyage du cache système..."
#sudo apt-get clean
#sudo apt-get autoremove -y

echo -e "${BLUE}✅ Nettoyage terminé!${NC}"
