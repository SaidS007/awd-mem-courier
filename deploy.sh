#!/bin/bash
set -e

echo " Déploiement de MEM Courrier avec Open-Capture..."

# Vérifications
if [ ! -f .env ]; then
    echo " Fichier .env non trouvé"
    echo " Création à partir de .env.example..."
    cp .env.example .env
    echo "  Veuillez configurer le fichier .env avant de continuer"
    exit 1
fi

# Charger la configuration
source .env

# Vérification des paramètres email
if [ -z "$EMAIL_USER" ] || [ -z "$EMAIL_PASSWORD" ]; then
    echo " ERREUR: EMAIL_USER et EMAIL_PASSWORD doivent être configurés dans .env"
    exit 1
fi

# Démarrer les services de base
echo " Démarrage de PostgreSQL et MEM Courrier..."
docker-compose up -d db-mc app-mc

echo " Attente du démarrage des services..."
sleep 30

# Télécharger Open-Capture
echo " Téléchargement d'Open-Capture for MEM..."
docker-compose up -d opencapture-installer

echo " Attente du téléchargement..."
sleep 10

# Installer Open-Capture
echo " Installation d'Open-Capture for MEM..."
docker-compose exec app-mc /bin/bash -c "
    cd /home/scripts && \
    chmod +x install-opencapture.sh && \
    ./install-opencapture.sh
"

echo " Déploiement terminé avec succès!"
echo ""
echo " ACCÈS AUX APPLICATIONS:"
echo "   MEM Courrier:      http://localhost:${APP_PORT:-8080}"
echo "   Open-Capture:      http://localhost:${APP_PORT:-8080}/opencapture"
echo ""
echo " IDENTIFIANTS:"
echo "   MEM:               admin / admin"
echo "   Open-Capture:      admin / admin"
echo ""
echo " CONFIGURATION EMAIL:"
echo "   Compte:            $EMAIL_USER"
echo ""
echo " CONSULTATION DES LOGS:"
echo "   docker-compose logs -f app-mc"
