FROM debian:bookworm-slim

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV MEM_VERSION=2505
ENV TERM=xterm

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    && curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-php.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list \
    && apt-get update

# Installation d'Apache, PHP et extensions
RUN apt-get install -y \
    apache2 \
    php8.1 \
    php8.1-cli \
    php8.1-common \
    php8.1-curl \
    php8.1-gd \
    php8.1-intl \
    php8.1-ldap \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-soap \
    php8.1-xml \
    php8.1-xmlrpc \
    php8.1-zip \
    php8.1-bcmath \
    php8.1-imagick \
    libapache2-mod-php8.1 \
    && a2enmod rewrite headers ssl

# Installation de PostgreSQL client et autres dépendances
RUN apt-get install -y \
    postgresql-client \
    git \
    unzip \
    cron \
    supervisor \
    # Nouvelles dépendances pour Maarch Courrier
    wkhtmltopdf \
    unoconv \
    nmap \
    ghostscript \
    poppler-utils \
    antiword \
    # Dépendances pour Open-Capture
    crudini \
    sudo \
    expect \
    postgresql \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configuration d'Apache
RUN sed -i 's/^ServerTokens.*/ServerTokens Prod/' /etc/apache2/conf-available/security.conf \
    && sed -i 's/^ServerSignature.*/ServerSignature Off/' /etc/apache2/conf-available/security.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configuration PHP
RUN sed -i 's/^;date.timezone =/date.timezone = Europe\/Paris/' /etc/php/8.1/apache2/php.ini \
    && sed -i 's/^;date.timezone =/date.timezone = Europe\/Paris/' /etc/php/8.1/cli/php.ini \
    && sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 100M/' /etc/php/8.1/apache2/php.ini \
    && sed -i 's/^post_max_size = .*/post_max_size = 100M/' /etc/php/8.1/apache2/php.ini \
    && sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php/8.1/apache2/php.ini \
    && sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php/8.1/apache2/php.ini

# Création des répertoires
RUN mkdir -p /var/www/html/MaarchCourrier \
    /opt/maarch/docservers \
    /var/log/maarch \
    /home/scripts \
    && chown -R www-data:www-data /var/www/html/MaarchCourrier /opt/maarch/docservers /var/log/maarch

# VirtualHost Apache pour MEM Courrier
COPY apache-mem.conf /etc/apache2/sites-available/mem-courrier.conf
RUN a2dissite 000-default.conf && a2ensite mem-courrier.conf

# Scripts d'installation - COPIER TOUS LES SCRIPTS
COPY docker-entrypoint.sh /home/scripts/
COPY healthcheck.sh /home/scripts/
COPY install-mem.sh /home/scripts/
COPY install-opencapture.sh /home/scripts/
RUN chmod +x /home/scripts/*.sh

# Exposition des ports
EXPOSE 80

WORKDIR /var/www/html/MaarchCourrier

# Point d'entrée
ENTRYPOINT ["/home/scripts/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
