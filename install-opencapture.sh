#!/bin/bash
set -e

echo " Installation d'Open-Capture for MEM..."

# Variables
OPENCAPTURE_PATH=${OPENCAPTURE_PATH:-/var/www/html/opencapture}
CUSTOM_ID=${CUSTOM_ID:-mycompany}
DB_HOST=${DB_HOST:-db-mc}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-mem}
DB_USER=${DB_USER:-edissyum}
DB_PASSWORD=${DB_PASSWORD:-edissyum}

# Vérifier si Open-Capture est déjà installé
if [ -f "$OPENCAPTURE_PATH/install.sh" ] && [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo " Open-Capture est déjà installé"
    echo " Virification de la configuration..."
    
    # Vérifier que les services sont actifs
    if systemctl is-active --quiet OCVerifier-worker_$CUSTOM_ID.service; then
        echo " Service OCVerifier actif"
    else
        echo " Démarrage du service OCVerifier..."
        systemctl start OCVerifier-worker_$CUSTOM_ID.service
    fi
    
    if systemctl is-active --quiet OCSplitter-worker_$CUSTOM_ID.service; then
        echo " Service OCSplitter actif"
    else
        echo " Démarrage du service OCSplitter..."
        systemctl start OCSplitter-worker_$CUSTOM_ID.service
    fi
    
    if systemctl is-active --quiet fs-watcher.service; then
        echo " Service fs-watcher actif"
    else
        echo " Démarrage du service fs-watcher..."
        systemctl start fs-watcher.service
    fi
    
    exit 0
fi

# Vérifier si le code source est présent
if [ ! -f "$OPENCAPTURE_PATH/install.sh" ]; then
    echo " Open-Capture n'est pas téléchargé"
    echo " Téléchargement en cours..."
    
    # Créer le répertoire si nécessaire
    mkdir -p $OPENCAPTURE_PATH
    
    # Télécharger depuis Git
    cd /tmp
    git clone https://github.com/edissyum/opencaptureformem.git opencapture_temp
    cp -r opencapture_temp/* $OPENCapture_PATH/
    rm -rf opencapture_temp
    
    if [ ! -f "$OPENCAPTURE_PATH/install.sh" ]; then
        echo " Échec du téléchargement"
        exit 1
    fi
    
    echo " Open-Capture téléchargé"
fi

# Attendre que la base de données soit prête
echo " Attente de la base de données..."
for i in {1..30}; do
    if pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME >/dev/null 2>&1; then
        echo " Base de données accessible"
        break
    fi
    if [ $i -eq 30 ]; then
        echo " Base de données non accessible après 60 secondes"
        exit 1
    fi
    sleep 2
done

# Installer Open-Capture
echo " Installation d'Open-Capture for MEM..."
cd $OPENCAPTURE_PATH

# Rendre le script exécutable
chmod +x install.sh

# Installation non-interactive
./install.sh \
    --user www-data \
    --custom_id $CUSTOM_ID \
    --supervisor_systemd systemd \
    --path $OPENCAPTURE_PATH \
    --database_hostname $DB_HOST \
    --database_port $DB_PORT \
    --database_username $DB_USER \
    --database_password $DB_PASSWORD \
    --database_name $DB_NAME \
    --docserver_path /var/docservers/opencapture \
    --python_venv_path /home/www-data/python-venv/opencapture \
    --share_path /var/share \
    --mem_path /var/www/html/MaarchCourrier

# Vérifier l'installation
if [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ] && [ -f "/etc/systemd/system/OCVerifier-worker_$CUSTOM_ID.service" ]; then
    echo " Open-Capture for MEM installé avec succès"
    
    # Démarrer les services
    echo " Démarrage des services..."
    systemctl daemon-reload
    systemctl enable OCVerifier-worker_$CUSTOM_ID.service
    systemctl enable OCSplitter-worker_$CUSTOM_ID.service
    systemctl enable fs-watcher.service
    
    systemctl start OCVerifier-worker_$CUSTOM_ID.service
    systemctl start OCSplitter-worker_$CUSTOM_ID.service
    systemctl start fs-watcher.service
    
    echo " Accès: http://localhost:${APP_PORT:-8080}/opencapture"
    echo " Identifiants: admin / admin"
    echo " Données persistées dans les volumes Docker"
else
    echo " Erreur lors de l'installation"
    exit 1
fi
