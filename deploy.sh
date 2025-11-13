#!/bin/bash
set -e

echo "🚀 Déploiement de MEM Courrier avec Open-Capture..."

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonctions utilitaires
print_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# Vérifier Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker n'est pas installé"
    echo "📥 Installation: sudo apt-get update && sudo apt-get install docker.io docker-compose"
    exit 1
fi

# Vérifier Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose n'est pas disponible"
    echo "📥 Installation: sudo apt-get install docker-compose-plugin"
    exit 1
fi

# Vérifier le fichier .env
if [ ! -f ".env" ]; then
    print_warning "Fichier .env non trouvé"
    if [ -f ".env.example" ]; then
        cp ".env.example" ".env"
        print_info "Fichier .env créé à partir de .env.example"
        echo "📝 Veuillez configurer le fichier .env avant de continuer"
        nano ".env" || vim ".env" || vi ".env"
    else
        print_error "Fichier .env.example non trouvé"
        exit 1
    fi
fi

# Charger les variables d'environnement
set -a
source .env
set +a

# Vérification des paramètres email
if [ -z "$EMAIL_USER" ] || [ -z "$EMAIL_PASSWORD" ]; then
    print_error "EMAIL_USER et EMAIL_PASSWORD doivent être configurés dans .env"
    exit 1
fi

# Vérifier si Open-Capture est déjà installé
print_info "Vérification de l'état de l'installation..."
if docker volume inspect mc_24_opencapture_data &> /dev/null; then
    print_success "Open-Capture est déjà installé"
    OPENCAPTURE_INSTALLED="true"
else
    print_info "Open-Capture nécessite une installation"
    OPENCAPTURE_INSTALLED="false"
fi

# Mettre à jour le .env avec l'état d'installation
if grep -q "OPENCAPTURE_INSTALLED" .env; then
    sed -i "s/OPENCAPTURE_INSTALLED=.*/OPENCAPTURE_INSTALLED=$OPENCAPTURE_INSTALLED/" .env
else
    echo "OPENCAPTURE_INSTALLED=$OPENCAPTURE_INSTALLED" >> .env
fi

# Créer les répertoires locaux
print_info "Création des répertoires..."
mkdir -p custom docservers librairies cron.d logs

# Donner les permissions appropriées
sudo chown -R $USER:$USER custom docservers librairies cron.d logs
sudo chmod -R 755 custom docservers librairies cron.d logs

# Démarrer les services
print_info "Démarrage des services..."
docker compose -p mc_24 -f docker-compose.yml --env-file .env up -d

if [ $? -ne 0 ]; then
    print_error "Erreur lors du démarrage des services"
    exit 1
fi

# Attendre le démarrage
print_info "Attente du démarrage des services (30 secondes)..."
sleep 30

# Vérifier l'état des services
print_info "Vérification de l'état des services..."
docker compose -p mc_24 -f compose.yml ps

# Installer Open-Capture seulement si nécessaire
if [ "$OPENCAPTURE_INSTALLED" = "false" ]; then
    print_info "Installation d'Open-Capture for MEM..."
    
    # Copier le script d'installation
    docker compose -p mc_24 -f compose.yml cp install-opencapture.sh app-mc:/home/scripts/
    
    # Donner les permissions d'exécution
    docker compose -p mc_24 -f compose.yml exec app-mc chmod +x /home/scripts/install-opencapture.sh
    
    # Exécuter l'installation
    docker compose -p mc_24 -f compose.yml exec app-mc /bin/bash -c "cd /home/scripts && ./install-opencapture.sh"
    
    if [ $? -eq 0 ]; then
        print_success "Open-Capture installé avec succès"
        # Mettre à jour le statut dans .env
        sed -i "s/OPENCAPTURE_INSTALLED=.*/OPENCAPTURE_INSTALLED=true/" .env
    else
        print_warning "L'installation a rencontré des problèmes"
        print_info "Vous pouvez réessayer manuellement:"
        echo "  docker compose -p mc_24 -f compose.yml exec app-mc /bin/bash"
        echo "  cd /home/scripts && ./install-opencapture.sh"
    fi
else
    print_info "Redémarrage des services Open-Capture..."
    docker compose -p mc_24 -f compose.yml exec app-mc /bin/bash -c \
        "systemctl restart OCVerifier-worker_mycompany.service OCSplitter-worker_mycompany.service fs-watcher.service 2>/dev/null || true"
fi

# Affichage final
print_success "Déploiement terminé!"
echo ""
echo "🌐 ACCÈS AUX APPLICATIONS:"
echo "   MEM Courrier:      http://localhost:${APP_PORT:-8080}"
echo "   Open-Capture:      http://localhost:${APP_PORT:-8080}/opencapture"
echo ""
echo "🔑 IDENTIFIANTS:"
echo "   MEM:               admin / admin"
echo "   Open-Capture:      admin / admin"
echo ""
echo "📁 DONNÉES PERSISTÉES DANS:"
echo "   - ./custom/              (configuration MEM)"
echo "   - ./docservers/          (documents MEM)"
echo "   - Volumes Docker:        mc_24_* (Open-Capture et base de données)"
echo ""
echo "🔍 POUR VERIFIER L'ÉTAT:"
echo "   ./check-status.sh"
echo ""
echo "💾 POUR SAUVEGARDER:"
echo "   ./backup.sh"
