@echo off
chcp 65001 >nul

echo 💾 Sauvegarde des données...

set BACKUP_DIR=backup_%date:~6,4%-%date:~3,2%-%date:~0,2%
mkdir %BACKUP_DIR% 2>nul

echo 📦 Sauvegarde des volumes...
docker run --rm -v mc_24_db-data:/source -v %CD%\%BACKUP_DIR%:/backup alpine tar czf /backup/db-data.tar.gz -C /source ./
docker run --rm -v mc_24_opencapture_data:/source -v %CD%\%BACKUP_DIR%:/backup alpine tar czf /backup/opencapture-data.tar.gz -C /source ./

echo 📁 Sauvegarde des fichiers locaux...
xcopy custom %BACKUP_DIR%\custom /E /I /Y >nul
xcopy docservers %BACKUP_DIR%\docservers /E /I /Y >nul

echo ✅ Sauvegarde terminée dans %BACKUP_DIR%
pause
