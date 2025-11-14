#!/bin/bash
set -e

echo "🚀 Démarrage de MEM Courrier..."

# Variables d'environnement
DB_HOST=${DB_HOST:-db-mc}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-mem}
DB_USER=${DB_USER:-memuser}
DB_PASSWORD=${DB_PASSWORD:-mempassword}
MEM_PATH=${MEM_PATH:-/var/www/html/MaarchCourrier}

# Démarrer les services
echo "🌐 Démarrage d'Apache..."
service apache2 start

echo "⏰ Démarrage de Cron..."
service cron start

# Attendre que la base de données soit prête
echo "⏳ Attente de la base de données PostgreSQL..."
for i in {1..30}; do
    if PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; then
        echo "✅ PostgreSQL est prêt"
        break
    fi
    echo "📊 En attente de PostgreSQL... ($i/30)"
    sleep 2
done

# Installation de MEM Courrier
echo "📦 Installation de MEM Courrier..."
/home/scripts/install-mem.sh

# Redémarrage final
echo "🔄 Redémarrage d'Apache..."
service apache2 reload

echo "✅ MEM Courrier est prêt!"
echo "🌐 Accès: http://localhost:${APP_PORT:-8080}"
echo "🔑 Pour finaliser l'installation, accédez à l'interface web"

# Installation d'Open-Capture si demandé
if [ "${INSTALL_OPENCAPTURE:-true}" = "true" ] && [ ! -f "/var/www/html/opencapture/install.sh" ]; then
    echo "📄 Installation d'Open-Capture for MEM..."
    if [ -f "/home/scripts/install-opencapture.sh" ]; then
        /home/scripts/install-opencapture.sh
    else
        echo "ℹ️  Script Open-Capture non trouvé, installation manuelle requise"
    fi
fi

# Garder le conteneur actif
echo "📝 Surveillance des logs..."
exec tail -f /var/log/apache2/*.log
