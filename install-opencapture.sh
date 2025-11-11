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
if [ ! -f "$OPENCAPTURE_PATH/install.sh" ]; then
    echo " Open-Capture n'est pas installé. Veuillez d'abord démarrer le conteneur opencapture-installer"
    exit 1
fi

# Attendre que la base de données soit prête
echo " Attente de la base de données..."
until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME; do
    sleep 2
done

# Installer Open-Capture
echo " Installation d'Open-Capture for MEM..."
cd $OPENCAPTURE_PATH

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

echo " Open-Capture for MEM installé avec succès"
echo " Accès: http://localhost:${APP_PORT:-8080}/opencapture"
echo " Identifiants: admin / admin"
