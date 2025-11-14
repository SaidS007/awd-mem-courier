#!/bin/bash

echo "🔍 Vérification de l'installation..."

# Vérifier les conteneurs
echo "🐳 Conteneurs:"
docker-compose -p mc_24 -f docker-compose.yml ps

# Vérifier MEM Courrier dans le conteneur
echo "📁 Fichiers MEM Courrier:"
docker-compose -p mc_24 -f docker-compose.yml exec app-mc ls -la /var/www/html/MaarchCourrier/ | head -10

# Vérifier l'accessibilité
echo "🌐 Test d'accès:"
curl -s -o /dev/null -w "Code HTTP: %{http_code}\n" http://localhost:8080/ || echo "❌ Impossible d'accéder"

# Vérifier les logs récents
echo "📋 Logs récents:"
docker-compose -p mc_24 -f docker-compose.yml logs app-mc --tail=20

