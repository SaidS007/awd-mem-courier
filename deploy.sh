#!/bin/bash
set -e

echo "🚀 Déploiement de MEM Courrier avec Open-Capture..."

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions
print_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# Vérifications
if ! command -v docker > /dev/null; then
    print_error "Docker n'est pas installé"
    exit 1
fi

if ! command -v docker-compose > /dev/null; then
    print_error "Docker Compose n'est pas installé"
    exit 1
fi

# Vérifier le mode Swarm
if docker info | grep -q "Swarm: active"; then
    print_warning "Docker est en mode Swarm - utilisation de docker-compose classique"
fi

# Vérifier le fichier .env
if [ ! -f ".env" ]; then
    print_warning "Fichier .env non trouvé"
    if [ -f ".env.example" ]; then
        cp ".env.example" ".env"
        print_info "Fichier .env créé à partir de .env.example"
        echo "📝 Veuillez configurer le fichier .env avant de continuer"
        ${EDITOR:-nano} ".env"
    else
        print_error "Fichier .env.example non trouvé"
        exit 1
    fi
fi

# Charger la configuration
set -a
source .env
set +a

# Vérifications des paramètres obligatoires
if [ -z "$EMAIL_USER" ] || [ -z "$EMAIL_PASSWORD" ]; then
    print_error "EMAIL_USER et EMAIL_PASSWORD doivent être configurés dans .env"
    exit 1
fi

# Vérifier que les scripts nécessaires existent
if [ ! -f "install-mem.sh" ]; then
    print_error "Le script install-mem.sh est manquant"
    echo "📝 Veuillez créer le fichier install-mem.sh avec le contenu fourni"
    exit 1
fi

# Nettoyage préalable
print_info "Nettoyage préalable..."
docker-compose -p mc_24 -f docker-compose.yml down 2>/dev/null || true

# Créer les répertoires
print_info "Création des répertoires..."
mkdir -p custom cron.d sql
#sudo chmod 755 custom cron.d sql

# Construction des images
print_info "Construction des images..."
if ! docker-compose -p mc_24 -f docker-compose.yml build --no-cache; then
    print_error "Échec de la construction des images"
    exit 1
fi

# Démarrage des services
print_info "Démarrage des services..."
if ! docker-compose -p mc_24 -f docker-compose.yml up -d; then
    print_error "Échec du démarrage des services"
    exit 1
fi

# Attendre le démarrage
print_info "Attente du démarrage des services (40 secondes)..."
sleep 40

# Vérification
print_info "Vérification de l'état des services..."
docker-compose -p mc_24 -f docker-compose.yml ps

# Vérifier que MEM Courrier s'est installé correctement
print_info "Vérification de l'installation de MEM Courrier..."
if docker-compose -p mc_24 -f docker-compose.yml exec -T app-mc test -f "/var/www/html/MaarchCourrier/index.php"; then
    print_success "MEM Courrier installé avec succès"
else
    print_warning "MEM Courrier n'est pas entièrement installé"
    echo "🔍 Vérifiez les logs: docker-compose -p mc_24 -f docker-compose.yml logs app-mc"
fi

# Installation d'Open-Capture
if [ "${INSTALL_OPENCAPTURE:-true}" = "true" ]; then
    print_info "Installation d'Open-Capture for MEM..."
    
    # Vérifier si Open-Capture est déjà installé
    if docker-compose -p mc_24 -f docker-compose.yml exec -T app-mc test -f "/var/www/html/opencapture/install.sh"; then
        print_info "Open-Capture est déjà installé"
    else
        # Copier et exécuter le script d'installation
        if [ -f "install-opencapture.sh" ]; then
            if docker-compose -p mc_24 -f docker-compose.yml exec -T app-mc /home/scripts/install-opencapture.sh; then
                print_success "Open-Capture installé avec succès"
                # Mettre à jour le .env
                if grep -q "OPENCAPTURE_INSTALLED" .env; then
                    sed -i "s/OPENCAPTURE_INSTALLED=.*/OPENCAPTURE_INSTALLED=true/" .env
                else
                    echo "OPENCAPTURE_INSTALLED=true" >> .env
                fi
            else
                print_warning "L'installation d'Open-Capture a rencontré des problèmes"
            fi
        else
            print_warning "Script install-opencapture.sh non trouvé"
        fi
    fi
fi

# Vérification finale
print_info "Vérification finale..."
if curl -s -f http://localhost:${APP_PORT:-8080} > /dev/null; then
    print_success "MEM Courrier est accessible"
else
    print_warning "MEM Courrier n'est pas encore accessible - vérifiez les logs"
fi

# Finalisation
print_success "Déploiement terminé!"
echo ""
echo "🌐 ACCÈS AUX APPLICATIONS:"
echo "   MEM Courrier: http://localhost:${APP_PORT:-8080}"
echo "   Open-Capture: http://localhost:${APP_PORT:-8080}/opencapture"
echo ""
echo "🔑 POUR FINALISER MEM COURRIER:"
echo "   1. Accédez à http://localhost:${APP_PORT:-8080}/install"
echo "   2. Suivez l'assistant d'installation"
echo "   3. Utilisez les identifiants de base de données configurés dans .env"
echo ""
echo "📋 COMMANDES UTILES:"
echo "   Vérifier les logs: docker-compose -p mc_24 -f docker-compose.yml logs app-mc"
echo "   Arrêter: docker-compose -p mc_24 -f docker-compose.yml down"
echo "   Redémarrer: docker-compose -p mc_24 -f docker-compose.yml restart"

