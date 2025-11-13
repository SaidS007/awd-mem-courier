@echo off
chcp 65001 >nul

echo 🔍 Vérification de l'état des services...

:: Vérifier les volumes
echo 📦 Volumes Docker:
docker volume ls | findstr "mc_24"

echo.

:: Vérifier les conteneurs
echo 🐳 Conteneurs:
docker compose -p mc_24 -f compose.yml ps

echo.

:: Vérifier l'état d'Open-Capture
echo 🔧 État d'Open-Capture:
docker compose -p mc_24 -f compose.yml exec app-mc /bin/bash -c "
    echo '📁 Installation:'; ls -la /var/www/html/opencapture/ 2>/dev/null | head -5 || echo 'Non installé';
    echo '🔧 Services:'; systemctl is-active OCVerifier-worker_mycompany.service OCSplitter-worker_mycompany.service fs-watcher.service 2>/dev/null || echo 'Services non configurés'
" 2>nul

echo.

:: URLs d'accès
echo 🌐 URLs d'accès:
echo    MEM Courrier:      http://localhost:8080
echo    Open-Capture:      http://localhost:8080/opencapture

echo.
pause
