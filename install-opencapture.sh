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
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-$DB_PASSWORD}

# Vérifier si Open-Capture est déjà installé
if [ -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ] && [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo "✅ Open-Capture est déjà installé"
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
    rm -f opencapture-master.zip
    rm -rf opencapture-master
    
    echo "🌐 Téléchargement de l'archive Open-Capture..."
    wget -q https://github.com/edissyum/opencapture/archive/refs/heads/master.zip -O opencapture-master.zip
    
    if [ ! -f "opencapture-master.zip" ]; then
        echo "❌ Échec du téléchargement"
        exit 1
    fi
    
    echo "📦 Extraction de l'archive..."
    unzip -q opencapture-master.zip
    
    if [ ! -d "opencapture-master" ]; then
        echo "❌ Échec de l'extraction"
        rm -f opencapture-master.zip
        exit 1
    fi
    
    echo "📁 Copie des fichiers..."
    cp -r opencapture-master/* $OPENCAPTURE_PATH/
    cp -r opencapture-master/.* $OPENCAPTURE_PATH/ 2>/dev/null || true
    
    # Nettoyer
    rm -f opencapture-master.zip
    rm -rf opencapture-master
    
    if [ ! -f "$OPENCAPTURE_INSTALL_PATH/install.sh" ]; then
        echo "❌ Échec de l'installation - fichier install.sh manquant"
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

# Préparer l'installation non-interactive avec expect
echo "🔧 Préparation de l'installation non-interactive..."

# Créer un script expect pour automatiser l'installation
cat > /tmp/install-opencapture.exp << EOF
#!/usr/bin/expect -f
set timeout 1800

spawn $OPENCAPTURE_INSTALL_PATH/install.sh --user www-data --custom_id "$CUSTOM_ID" --supervisor_systemd systemd --path "$OPENCAPTURE_PATH" --wsgi_threads 5 --wsgi_process 1 --database_hostname "$DB_HOST" --database_port "$DB_PORT" --database_username "$DB_USER" --database_password "$DB_PASSWORD" --docserver_path "$DOCSERVERS_PATH" --python_venv_path "$PYTHON_VENV_PATH" --share_path "$SHARE_PATH"

expect {
    "Postgres user Password*" {
        send "$POSTGRES_PASSWORD\r"
        exp_continue
    }
    eof
}
EOF

chmod +x /tmp/install-opencapture.exp

# Installer Open-Capture
echo "📦 Installation d'Open-Capture..."
cd $OPENCAPTURE_INSTALL_PATH

# Vérifier les permissions
echo "🔐 Configuration des permissions..."
chown -R www-data:www-data "$OPENCAPTURE_PATH"
find "$OPENCAPTURE_PATH" -type d -exec chmod 755 {} \;
find "$OPENCAPTURE_PATH" -type f -exec chmod 644 {} \;

# Rendre le script d'installation exécutable
chmod +x install.sh

# Lancer l'installation automatisée
echo "🛠️ Lancement de l'installation automatisée..."
/tmp/install-opencapture.exp

# Vérifier l'installation
if [ -d "$OPENCAPTURE_PATH/custom/$CUSTOM_ID" ]; then
    echo "✅ Open-Capture installé avec succès"
    
    # Configuration des permissions finales
    echo "🔐 Configuration finale des permissions..."
    chown -R www-data:www-data "$OPENCAPTURE_PATH" "$DOCSERVERS_PATH" "$SHARE_PATH"
    chmod -R 775 "$OPENCAPTURE_PATH" "$DOCSERVERS_PATH" "$SHARE_PATH"
    
    echo "🌐 Accès: http://localhost:\${APP_PORT:-8080}/opencapture"
    echo "🔑 Identifiants par défaut: admin / admin"
else
    echo "❌ Erreur lors de l'installation"
    echo "📋 Vérifiez les logs dans $OPENCAPTURE_PATH/install_info.log et $OPENCAPTURE_PATH/install_error.log"
    exit 1
fi

# Nettoyer
rm -f /tmp/install-opencapture.exp
