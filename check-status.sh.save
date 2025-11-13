#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔍 Vérification de l'état des services...${NC}"

# Vérifier les volumes
echo -e "${BLUE}📦 Volumes Docker:${NC}"
docker volume ls | grep mc_24

echo

# Vérifier les conteneurs
echo -e "${BLUE}🐳 Conteneurs:${NC}"
docker compose -p mc_24 -f compose.yml ps

echo

# Vérifier l'état d'Open-Capture
echo -e "${BLUE}🔧 État d'Open-Capture:${NC}"
docker compose -p mc_24 -f compose.yml exec app-mc /bin/bash -c "
    echo '📁 Installation:'
    if [ -d '/var/www/html/opencapture' ]; then
        ls -la /var/www/html/opencapture/ | head -5
        echo
        echo ' Services:'
        systemctl is-active OCVerifier-worker_mycompany.service && echo ' OCVerifier: actif' || echo ' OCVerifier: inactif'
        systemctl is-active OCSplitter-worker_mycompany.service && echo ' OCSplitter: actif' || echo ' OCSplitter: inactif'
        systemctl is-active fs-watcher.service && echo ' fs-watcher: actif' || echo ' fs-watcher: inactif'
    else
        echo ' Open-Capture non installé'
    fi
" 2>/dev/null || echo -e "${YELLOW} Impossible de vérifier l'état d'Open-Capture${NC}"

echo

# Vérifier l'espace disque
echo -e "${BLUE} Utilisation du disque:${NC}"
df -h | grep -E "Filesystem|/dev/"

echo

# URLs d'accès
echo -e "${BLUE}🌐 URLs d'accès:${NC}"
echo "   MEM Courrier:      http://localhost:8080"
echo "   Open-Capture:      http://localhost:8080/opencapture"

echo
