@echo off
echo Execution du script de deploiement MEM Courrier...
echo.

:: Vérifier si Git Bash est disponible
where bash >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Git Bash n'est pas installe ou n'est pas dans le PATH
    echo Telechargez-le depuis: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: Rendre le script executable et l'executer
bash -c "chmod +x deploy.sh && ./deploy.sh"

:: Pause pour voir les resultats
pause
