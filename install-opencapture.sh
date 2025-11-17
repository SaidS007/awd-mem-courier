#!/bin/bash
set -e

echo "🚀 Installation d'Open-Capture..."

# Variables
OPENCAPTURE_PATH=${OPENCAPTURE_PATH:-/var/www/html/opencapture}
OPENCAPTURE_INSTALL_PATH="$OPENCAPTURE_PATH/install"
CUSTOM_ID=${CUSTOM_ID:-mycompany}
DB_HOST=${DB_HOST:-db-mc}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-mem}
DB_USER=${DB_USER:-memuser}
DB_PASSWORD=${DB_PASSWORD:-mempassword}
DOCSERVERS_PATH=${DOCSERVERS_PATH:-/var/docservers/opencapture}
PYTHON_VENV_PATH=${PYTHON_VENV_PATH:-/home/www-data/python-venv/opencapture}
SHARE_PATH=${SHARE_PATH:-/var/share}

# Vérifier si Open-Capture est déjà installé
if [ -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ] && [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo "✅ Open-Capture est déjà installé"
    echo "🔧 Vérification de la configuration..."
    
    # Vérifier que les services sont actifs
    if systemctl is-active --quiet "OCVerifier-worker_$CUSTOM_ID.service" 2>/dev/null; then
        echo "✅ Service OCVerifier actif"
    else
        echo "🔄 Démarrage du service OCVerifier..."
        systemctl start "OCVerifier-worker_$CUSTOM_ID.service" 2>/dev/null || true
    fi
    
    if systemctl is-active --quiet "OCSplitter-worker_$CUSTOM_ID.service" 2>/dev/null; then
        echo "✅ Service OCSplitter actif"
    else
        echo "🔄 Démarrage du service OCSplitter..."
        systemctl start "OCSplitter-worker_$CUSTOM_ID.service" 2>/dev/null || true
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
    echo "📥 Téléchargement de l'archive ZIP..."
    
    # Créer le répertoire si nécessaire
    mkdir -p $OPENCAPTURE_PATH
    
    # Télécharger l'archive ZIP
    cd /tmp
    
    # NETTOYAGE : Supprimer les fichiers temporaires s'ils existent
    if [ -f "opencapture-master.zip" ]; then
        echo "🧹 Nettoyage de l'archive existante..."
        rm -f opencapture-master.zip
    fi
    
    if [ -d "opencapture-master" ]; then
        echo "🧹 Nettoyage du dossier temporaire existant..."
        rm -rf opencapture-master
    fi
    
    echo "🌐 Téléchargement de l'archive Open-Capture..."
    wget -q https://github.com/edissyum/opencapture/archive/refs/heads/master.zip -O opencapture-master.zip
    
    # Vérifier que le téléchargement a réussi
    if [ ! -f "opencapture-master.zip" ]; then
        echo "❌ Échec du téléchargement"
        exit 1
    fi
    
    echo "📦 Extraction de l'archive..."
    unzip -q opencapture-master.zip
    
    # Vérifier que l'extraction a réussi
    if [ ! -d "opencapture-master" ]; then
        echo "❌ Échec de l'extraction"
        rm -f opencapture-master.zip
        exit 1
    fi
    
    echo "📁 Copie des fichiers..."
    cp -r opencapture-master/* $OPENCAPTURE_PATH/
    cp -r opencapture-master/.* $OPENCAPTURE_PATH/ 2>/dev/null || true
    
    # Nettoyer
    echo "🧹 Nettoyage des fichiers temporaires..."
    rm -f opencapture-master.zip
    rm -rf opencapture-master
    
    if [ ! -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ]; then
        echo "❌ Échec de l'installation - fichier install.sh manquant"
        echo "📁 Contenu du répertoire $OPENCAPTURE_PATH :"
        ls -la "$OPENCAPTURE_PATH"
        exit 1
    fi
    
    echo "✅ Open-Capture téléchargé et extrait"
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
echo "📦 Installation d'Open-Capture..."
cd $OPENCAPTURE_INSTALL_PATH

# Vérifier les permissions
echo "🔐 Configuration des permissions..."
chown -R www-data:www-data "$OPENCAPTURE_PATH"
find "$OPENCAPTURE_PATH" -type d -exec chmod 755 {} \;
find "$OPENCAPTURE_PATH" -type f -exec chmod 644 {} \;

# Rendre le script d'installation exécutable
echo "🔧 Préparation du script d'installation..."
chmod +x install.sh

# Vérifier que le script est exécutable
if [ ! -x "install.sh" ]; then
    echo "❌ Le script install.sh n'est pas exécutable après chmod"
    ls -la install.sh
    exit 1
fi

# Installation non-interactive avec tous les paramètres requis
echo "🛠️ Lancement de l'installation d'Open-Capture..."
./install.sh \
    --user www-data \
    --custom_id "$CUSTOM_ID" \
    --supervisor_systemd systemd \
    --path "$OPENCAPTURE_PATH" \
    --wsgi_threads 5 \
    --wsgi_process 1 \
    --database_hostname "$DB_HOST" \
    --database_port "$DB_PORT" \
    --database_username "$DB_USER" \
    --database_password "$DB_PASSWORD" \
    --docserver_path "$DOCSERVERS_PATH" \
    --python_venv_path "$PYTHON_VENV_PATH" \
    --share_path "$SHARE_PATH"

# Vérifier l'installation
if [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo "✅ Open-Capture installé avec succès"
    
    # Démarrer les services
    echo "🔧 Démarrage des services..."
    systemctl daemon-reload 2>/dev/null || true
    
    # Activer et démarrer les services si systemd est disponible
    if command -v systemctl >/dev/null; then
        systemctl enable "OCVerifier-worker_$CUSTOM_ID.service" 2>/dev/null || true
        systemctl enable "OCSplitter-worker_$CUSTOM_ID.service" 2>/dev/null || true
        systemctl enable fs-watcher.service 2>/dev/null || true
        
        systemctl start "OCVerifier-worker_$CUSTOM_ID.service" 2>/dev/null || true
        systemctl start "OCSplitter-worker_$CUSTOM_ID.service" 2>/dev/null || true
        systemctl start fs-watcher.service 2>/dev/null || true
        
        echo "✅ Services Open-Capture démarrés"
    fi
    
    # Configuration des permissions finales
    echo "🔐 Configuration finale des permissions..."
    chown -R www-data:www-data "$OPENCAPTURE_PATH"
    chown -R www-data:www-data "$DOCSERVERS_PATH"
    chown -R www-data:www-data "$SHARE_PATH"
    chmod -R 775 "$OPENCAPTURE_PATH" "$DOCSERVERS_PATH" "$SHARE_PATH"
    
    echo "🌐 Accès: http://localhost:${APP_PORT:-8080}/opencapture"
    echo "🔑 Identifiants par défaut: admin / admin"
    echo "📁 Données persistées dans les volumes Docker"
    echo ""
    echo "⚠️  IMPORTANT: Après la première connexion, changez le mot de passe admin !"
else
    echo "❌ Erreur lors de l'installation - le custom directory n'a pas été créé"
    echo "📋 Vérifiez les logs dans:"
    echo "   - $OPENCAPTURE_PATH/install_info.log" 
    echo "   - $OPENCAPTURE_PATH/install_error.log"
    echo "🔍 Logs système: journalctl -u OCVerifier-worker_$CUSTOM_ID.service"
    exit 1
fi
