#!/bin/bash
set -e

echo " Démarrage de MEM Courrier avec Open-Capture..."

# Variables depuis l'environnement
USER=${USER:-opencapture}
CUSTOM_ID=${CUSTOM_ID:-mycompany}
MEM_PATH=${MEM_PATH:-/var/www/html/MaarchCourrier}
OPEN_CAPTURE_PATH=${OPEN_CAPTURE_PATH:-/var/www/html/opencapture}

# Démarrer les services de base
echo " Démarrage de PostgreSQL..."
service postgresql start

echo " Démarrage d'Apache..."
service apache2 start

echo " Démarrage de Cron..."
service cron start

# Attendre que les services soient prêts
sleep 5

# Vérifier si MEM est déjà installé
if [ ! -f "$MEM_PATH/config/database.php" ]; then
    echo " Installation de MEM Courrier..."
    
    # Lancer l'installation de MEM
    cd $MEM_PATH/install
    php install.php \
        --db-host localhost \
        --db-port 5432 \
        --db-name mem_$CUSTOM_ID \
        --db-user $USER \
        --db-password $USER \
        --admin-password admin \
        --email ${EMAIL_USER} \
        --company "My Company" \
        --lang fr
else
    echo "  MEM Courrier est déjà installé"
fi

# Installation d'Open-Capture for MEM
if [ ! -f "$OPEN_CAPTURE_PATH/install.sh" ]; then
    echo " Installation d'Open-Capture for MEM..."
    
    # Télécharger Open-Capture for MEM
    cd /tmp
    git clone https://github.com/edissyum/opencaptureformem.git $OPEN_CAPTURE_PATH
    
    # Lancer l'installation
    cd $OPEN_CAPTURE_PATH
    chmod +x install.sh
    
    ./install.sh \
        --user $USER \
        --custom_id $CUSTOM_ID \
        --supervisor_systemd ${SUPERVISOR_SYSTEMD:-systemd} \
        --path $OPEN_CAPTURE_PATH \
        --database_hostname localhost \
        --database_port 5432 \
        --database_username $USER \
        --database_password $USER \
        --database_name mem_$CUSTOM_ID \
        --docserver_path ${DOCSERVER_PATH:-/var/docservers/opencapture} \
        --python_venv_path ${PYTHON_VENV_PATH:-/home/$USER/python-venv/opencapture} \
        --share_path ${SHARE_PATH:-/var/share} \
        --mem_path $MEM_PATH
    
    echo " Open-Capture for MEM installé"
else
    echo "  Open-Capture for MEM est déjà installé"
fi

# Configuration de l'intégration
echo " Configuration de l'intégration..."
configure_integration() {
    # Créer les liens entre MEM et Open-Capture
    ln -sf $MEM_PATH $OPEN_CAPTURE_PATH/custom/$CUSTOM_ID/bin/scripts/MailCollect/mem || true
    
    # Configurer les services
    if [ -f "/etc/systemd/system/OCVerifier-worker_$CUSTOM_ID.service" ]; then
        systemctl enable OCVerifier-worker_$CUSTOM_ID.service
        systemctl start OCVerifier-worker_$CUSTOM_ID.service
    fi
    
    if [ -f "/etc/systemd/system/OCSplitter-worker_$CUSTOM_ID.service" ]; then
        systemctl enable OCSplitter-worker_$CUSTOM_ID.service
        systemctl start OCSplitter-worker_$CUSTOM_ID.service
    fi
    
    if [ -f "/etc/systemd/system/fs-watcher.service" ]; then
        systemctl enable fs-watcher.service
        systemctl start fs-watcher.service
    fi
}

configure_integration

echo " Installation terminée avec succès!"
echo ""
echo " Accès à MEM Courrier: http://localhost:8080"
echo " Accès à Open-Capture: http://localhost:8080/opencapture"
echo " Identifiants MEM: admin / admin"
echo " Identifiants Open-Capture: admin / admin"
echo " Email configuré: ${EMAIL_USER}"

# Health check
echo " Vérification de l'état des services..."
if pgrep -x "apache2" > /dev/null && pgrep -x "postgres" > /dev/null; then
    echo " Tous les services fonctionnent correctement"
else
    echo "  Certains services peuvent ne pas fonctionner correctement"
fi

# Garder le conteneur actif
echo " Logs disponibles dans:"
echo "   - MEM: $MEM_PATH/var/log/"
echo "   - Open-Capture: $OPEN_CAPTURE_PATH/custom/$CUSTOM_ID/data/log/"
echo ""
echo " Conteneur démarré avec succès!"

# Exécuter l'entrypoint original de MEM si nécessaire
if [ -f "/bin/entrypoint.sh" ]; then
    exec /bin/entrypoint.sh "$@"
else
    # Sinon garder le conteneur en vie
    tail -f /var/log/apache2/error.log
fi
