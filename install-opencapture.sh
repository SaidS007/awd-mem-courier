#!/bin/bash
set -e

echo "🚀 Installation d'Open-Capture for MEM..."

# Variables
OPENCAPTURE_PATH=${OPENCAPTURE_PATH:-/var/www/html/opencapture}
OPENCAPTURE_INSTALL_PATH="$OPENCAPTURE_PATH/install"
CUSTOM_ID=${CUSTOM_ID:-mycompany}
DB_HOST=${DB_HOST:-db-mc}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-mem}
DB_USER=${DB_USER:-memuser}
DB_PASSWORD=${DB_PASSWORD:-mempassword}

# Vérifier si Open-Capture est déjà installé
if [ -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ] && [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo "✅ Open-Capture est déjà installé"
    echo "🔧 Vérification de la configuration..."
    
    # Vérifier que les services sont actifs
    if systemctl is-active --quiet OCVerifier-worker_$CUSTOM_ID.service 2>/dev/null; then
        echo "✅ Service OCVerifier actif"
    else
        echo "🔄 Démarrage du service OCVerifier..."
        systemctl start OCVerifier-worker_$CUSTOM_ID.service 2>/dev/null || true
    fi
    
    if systemctl is-active --quiet OCSplitter-worker_$CUSTOM_ID.service 2>/dev/null; then
        echo "✅ Service OCSplitter actif"
    else
        echo "🔄 Démarrage du service OCSplitter..."
        systemctl start OCSplitter-worker_$CUSTOM_ID.service 2>/dev/null || true
    fi
    
    if systemctl is-active --quiet fs-watcher.service 2>/dev/null; then
        echo "✅ Service fs-watcher actif"
    else
        echo "🔄 Démarrage du service fs-watcher..."
        systemctl start fs-watcher.service 2>/dev/null || true
    fi
    
    exit 0
fi

# Vérifier si le code source est présent
if [ ! -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ]; then
    echo "❌ Open-Capture n'est pas téléchargé"
    echo "📥 Téléchargement en cours..."
    
    # Créer le répertoire si nécessaire
    mkdir -p $OPENCAPTURE_PATH
    
    # Télécharger depuis Git
    cd /tmp
    
    # NETTOYAGE : Supprimer le dossier temporaire s'il existe
    if [ -d "opencapture_temp" ]; then
        echo "🧹 Nettoyage du dossier temporaire existant..."
        rm -rf opencapture_temp
    fi
    
    echo "🌐 Clonage du repository Open-Capture..."
    git clone https://github.com/edissyum/opencaptureformem.git opencapture_temp
    
    # Vérifier que le clone a réussi
    if [ ! -d "opencapture_temp" ]; then
        echo "❌ Échec du clonage"
        exit 1
    fi
    
    echo "📁 Copie des fichiers..."
    cp -r opencapture_temp/* $OPENCAPTURE_PATH/
    cp -r opencapture_temp/.* $OPENCAPTURE_PATH/ 2>/dev/null || true
    
    # Nettoyer
    rm -rf opencapture_temp
    
    if [ ! -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ]; then
        echo "❌ Échec du téléchargement - fichier install.sh manquant"
        exit 1
    fi
    
    echo "✅ Open-Capture téléchargé"
fi

# Attendre que la base de données soit prête
echo "⏳ Attente de la base de données..."
for i in {1..30}; do
    if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c '\q' >/dev/null 2>&1; then
        echo "✅ Base de données accessible"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Base de données non accessible après 60 secondes"
        exit 1
    fi
    sleep 2
done

# Installer Open-Capture
echo "📦 Installation d'Open-Capture for MEM..."
cd $OPENCAPTURE_INSTALL_PATH

# Vérifier les permissions
echo "🔐 Configuration des permissions..."
chown -R www-data:www-data "$OPENCAPTURE_PATH"
find "$OPENCAPTURE_PATH" -type d -exec chmod 755 {} \;
find "$OPENCAPTURE_PATH" -type f -exec chmod 644 {} \;

# Rendre le script exécutable
chmod 755 install.sh

# Vérifier que le script est exécutable
if [ ! -x "install.sh" ]; then
   ls -l "$OPENCAPTURE_INSTALL_PATH/install.sh"
   echo "❌ Le script install.sh n'est pas exécutable"
   exit 1
fi

# Installation non-interactive
echo "🛠️ Lancement de l'installation..."
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
if [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo "✅ Open-Capture for MEM installé avec succès"
    
    # Démarrer les services
    echo "🔧 Démarrage des services..."
    systemctl daemon-reload 2>/dev/null || true
    
    # Activer et démarrer les services si systemd est disponible
    if command -v systemctl >/dev/null; then
        systemctl enable OCVerifier-worker_$CUSTOM_ID.service 2>/dev/null || true
        systemctl enable OCSplitter-worker_$CUSTOM_ID.service 2>/dev/null || true
        systemctl enable fs-watcher.service 2>/dev/null || true
        
        systemctl start OCVerifier-worker_$CUSTOM_ID.service 2>/dev/null || true
        systemctl start OCSplitter-worker_$CUSTOM_ID.service 2>/dev/null || true
        systemctl start fs-watcher.service 2>/dev/null || true
    fi
    
    echo "🌐 Accès: http://localhost:${APP_PORT:-8080}/opencapture"
    echo "🔑 Identifiants: admin / admin"
    echo "📁 Données persistées dans les volumes Docker"
else
    echo "❌ Erreur lors de l'installation - le custom directory n'a pas été créé"
    echo "📋 Vérifiez les logs dans $OPENCAPTURE_PATH/install.log"
    exit 1
fi
