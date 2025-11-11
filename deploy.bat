@echo off
setlocal enabledelayedexpansion

echo  Déploiement de MEM Courrier avec Open-Capture...

:: Vérifier si le fichier .env existe
if not exist .env (
    echo  Fichier .env non trouvé
    echo  Création à partir de .env.example...
    copy .env.sample .env
    echo   Veuillez configurer le fichier .env avant de continuer
    exit /b 1
)

:: Charger les variables d'environnement depuis le fichier .env
for /f "usebackq delims=" %%i in (".env") do (
    set "line=%%i"
    if not "!line:~0,1!"=="#" (
        set "key=!line:~0,1!"
        set "key=!line: =!"
        for /f "tokens=1,2 delims==" %%a in ("!line!") do (
            set "%%a=%%b"
        )
    )
)

:: Vérification des paramètres email
if "%EMAIL_USER%"=="" (
    echo  ERREUR: EMAIL_USER doit être configuré dans .env
    exit /b 1
)
if "%EMAIL_PASSWORD%"=="" (
    echo  ERREUR: EMAIL_PASSWORD doit être configuré dans .env
    exit /b 1
)

:: Démarrer les services de base
echo  Démarrage de PostgreSQL et MEM Courrier...
docker-compose up -d db-mc app-mc

echo  Attente du démarrage des services...
timeout /t 30 /nobreak

:: Télécharger Open-Capture
echo  Téléchargement d'Open-Capture for MEM...
docker-compose up -d opencapture-installer

echo  Attente du téléchargement...
timeout /t 10 /nobreak

:: Installer Open-Capture
echo  Installation d'Open-Capture for MEM...
docker-compose exec app-mc /bin/bash -c "cd /home/scripts && chmod +x install-opencapture.sh && ./install-opencapture.sh"

echo  Déploiement terminé avec succès!
echo.
echo  ACCÈS AUX APPLICATIONS:
echo    MEM Courrier:      http://localhost:%APP_PORT%
echo    Open-Capture:      http://localhost:%APP_PORT%/opencapture
echo.
echo  IDENTIFIANTS:
echo    MEM:               admin / admin
echo    Open-Capture:      admin / admin
echo.
echo  CONFIGURATION EMAIL:
echo    Compte:            %EMAIL_USER%
echo.
echo  CONSULTATION DES LOGS:
echo    docker-compose logs -f app-mc

endlocal
