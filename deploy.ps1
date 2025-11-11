# deploy.ps1 - Script de déploiement pour Windows PowerShell

Write-Host " Déploiement de MEM Courrier avec Open-Capture..." -ForegroundColor Green

# Vérifier si le fichier .env existe
if (-not (Test-Path .env)) {
    Write-Host " Fichier .env non trouvé" -ForegroundColor Red
    Write-Host " Création à partir de .env.example..." -ForegroundColor Yellow
    Copy-Item .env.sample .env
    Write-Host "  Veuillez configurer le fichier .env avant de continuer" -ForegroundColor Yellow
    exit 1
}

# Charger les variables d'environnement depuis le fichier .env
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([^#]\S+)\s*=\s*(.*)\s*$') {
        $key = $matches[1]
        $value = $matches[2]
        Set-Item -Path "env:$key" -Value $value
    }
}

# Vérification des paramètres email
if (-not $env:EMAIL_USER -or -not $env:EMAIL_PASSWORD) {
    Write-Host " ERREUR: EMAIL_USER et EMAIL_PASSWORD doivent être configurés dans .env" -ForegroundColor Red
    exit 1
}

# Démarrer les services de base
Write-Host " Démarrage de PostgreSQL et MEM Courrier..." -ForegroundColor Green
docker-compose up -d db-mc app-mc

Write-Host " Attente du démarrage des services..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Télécharger Open-Capture
Write-Host " Téléchargement d'Open-Capture for MEM..." -ForegroundColor Green
docker-compose up -d opencapture-installer

Write-Host " Attente du téléchargement..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Installer Open-Capture
Write-Host " Installation d'Open-Capture for MEM..." -ForegroundColor Green
docker-compose exec app-mc /bin/bash -c "cd /home/scripts && chmod +x install-opencapture.sh && ./install-opencapture.sh"

Write-Host " Déploiement terminé avec succès!" -ForegroundColor Green
Write-Host ""
Write-Host " ACCÈS AUX APPLICATIONS:" -ForegroundColor Cyan
Write-Host "   MEM Courrier:      http://localhost:$($env:APP_PORT)" -ForegroundColor White
Write-Host "   Open-Capture:      http://localhost:$($env:APP_PORT)/opencapture" -ForegroundColor White
Write-Host ""
Write-Host " IDENTIFIANTS:" -ForegroundColor Cyan
Write-Host "   MEM:               admin / admin" -ForegroundColor White
Write-Host "   Open-Capture:      admin / admin" -ForegroundColor White
Write-Host ""
Write-Host " CONFIGURATION EMAIL:" -ForegroundColor Cyan
Write-Host "   Compte:            $env:EMAIL_USER" -ForegroundColor White
Write-Host ""
Write-Host " CONSULTATION DES LOGS:" -ForegroundColor Cyan
Write-Host "   docker-compose logs -f app-mc" -ForegroundColor White
