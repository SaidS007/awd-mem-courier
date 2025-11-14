#!/bin/bash
set -e

echo "📦 Installation de MEM Courrier..."

MEM_PATH=${MEM_PATH:-/var/www/html/MaarchCourrier}
DB_HOST=${DB_HOST:-db-mc}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-mem}
DB_USER=${DB_USER:-memuser}
DB_PASSWORD=${DB_PASSWORD:-mempassword}

cd "$MEM_PATH"

# Vérifier si MEM Courrier est déjà présent
if [ -f "index.php" ] && [ -d "modules" ]; then
    echo "✅ MEM Courrier est déjà installé"
    exit 0
fi

echo "📥 Téléchargement de MEM Courrier..."
# Créer la structure de base
mkdir -p var/log var/cache var/sessions tmp custom
chown -R www-data:www-data var tmp custom

# Si MEM n'est pas présent, on va le télécharger
if [ ! -f "composer.json" ]; then
    echo "🌐 Téléchargement depuis GitLab..."
    
    # Télécharger MEM Courrier
    cd /tmp
    git clone https://gitlab.com/edissyum/mem/2505.git mem-download
    cp -r mem-download/* "$MEM_PATH"/
    cp -r mem-download/.* "$MEM_PATH"/ 2>/dev/null || true
    rm -rf mem-download
    
    cd "$MEM_PATH"
    
    # Vérifier le téléchargement
    if [ ! -f "composer.json" ]; then
        echo "❌ Échec du téléchargement de MEM Courrier"
        exit 1
    fi
    echo "✅ MEM Courrier téléchargé"
fi

# Installation des dépendances Composer
if [ -f "composer.json" ] && [ ! -d "vendor" ]; then
    echo "📦 Installation des dépendances PHP..."
    composer install --no-dev --optimize-autoloader --no-interaction
    
    if [ $? -ne 0 ]; then
        echo "⚠️  Échec de l'installation Composer, tentative alternative..."
        # Tentative avec des permissions relaxées
        chmod -R 775 "$MEM_PATH"
        composer install --no-dev --optimize-autoloader --no-interaction --no-scripts
    fi
fi

# Configuration des permissions finales
echo "🔐 Configuration des permissions..."
chown -R www-data:www-data "$MEM_PATH"
find "$MEM_PATH" -type d -exec chmod 755 {} \;
find "$MEM_PATH" -type f -exec chmod 644 {} \;
chmod -R 775 "$MEM_PATH/var" "$MEM_PATH/tmp" "/opt/maarch/docservers" 2>/dev/null || true

# Créer la configuration de base si elle n'existe pas
if [ ! -f "config/database.php" ]; then
    echo "⚙️ Création de la configuration de base..."
    mkdir -p config
    cat > config/database.php << EOF
<?php
return [
    'database' => [
        'host' => '$DB_HOST',
        'port' => '$DB_PORT',
        'name' => '$DB_NAME',
        'user' => '$DB_USER',
        'password' => '$DB_PASSWORD'
    ]
];
EOF
    chown www-data:www-data config/database.php
    chmod 644 config/database.php
fi

echo "✅ Installation de MEM Courrier terminée"
echo "🌐 Vous pouvez maintenant accéder à MEM Courrier pour finaliser l'installation via le navigateur"
