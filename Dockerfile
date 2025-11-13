# Utilise l'image de base MEM Courrier
FROM docker.io/php:8.1-apache-bullseye

# Copy dependencies lists
COPY ./container/dependences.apt ./container/dependences.php /mnt/

## Dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y debsecan \
    && apt-get install --no-install-recommends -y $(debsecan --suite buster --format packages --only-fixed) \
    && apt-get purge -y debsecan \
    && apt-get install --no-install-recommends -y $(cat /mnt/dependences.apt) \
    && sed -i 's/rights="none" pattern="PDF"/rights="read" pattern="PDF"/' /etc/ImageMagick-6/policy.xml \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /mnt/dependences.apt \
    && curl -sSLf \
               -o /usr/local/bin/install-php-extensions \
               https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions

RUN chmod +x /usr/local/bin/install-php-extensions  \
    && install-php-extensions $(cat /mnt/dependences.php) \
    && rm -rf /usr/local/bin/install-php-extensions \
    && rm -rf /mnt/dependences.php \
    && echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && echo "LC_ALL=fr_FR.UTF-8" > /etc/environment \
    && a2enmod rewrite headers

## Application files
RUN mkdir -p --mode=700 /var/www/html/MaarchCourrier /var/www/html/MaarchCourrier/dist /opt/maarch/docservers \
  && chown www-data:www-data /var/www/html/MaarchCourrier /opt/maarch/docservers
RUN touch /var/www/html/MaarchCourrier/dist/index.html

WORKDIR /var/www/html/MaarchCourrier

## Openssl config
COPY --chmod=644 container/openssl.cnf /etc/ssl/openssl.cnf

# Apache vhost
COPY container/default-vhost.conf /etc/apache2/sites-available/000-default.conf

# PHP Configuration
COPY container/php.ini /usr/local/etc/php/php.ini

RUN mkdir -p /home/scripts
COPY --chown=www-data:www-data container/initialize_app.sh /home/scripts/initialize_app.sh
COPY --chown=www-data:www-data container/initialize_db.sh /home/scripts/initialize_db.sh
RUN chmod +x /home/scripts/initialize_app.sh && chmod +x /home/scripts/initialize_db.sh

# Set default healthcheck
COPY --chown=root:root --chmod=500 container/healthcheck.sh /bin/healthcheck.sh

# run cron in the background
RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground

#
# Base APP
#

# Copy the app files inside the container
COPY --chown=www-data:www-data index.php LICENSE.txt CONTRIBUTING.md *.md .htaccess /var/www/html/MaarchCourrier/
COPY --chown=www-data:www-data modules /var/www/html/MaarchCourrier/modules
COPY --chown=www-data:www-data install /var/www/html/MaarchCourrier/install
COPY --chown=www-data:www-data rest /var/www/html/MaarchCourrier/rest
COPY --chown=www-data:www-data bin /var/www/html/MaarchCourrier/bin
COPY --chown=www-data:www-data config /var/www/html/MaarchCourrier/config
COPY --chown=www-data:www-data referential /var/www/html/MaarchCourrier/referential
COPY --chown=www-data:www-data sql /var/www/html/MaarchCourrier/sql
COPY --chown=www-data:www-data migration /var/www/html/MaarchCourrier/migration
COPY --chown=www-data:www-data package.json package-lock.json composer.json composer.lock /var/www/html/MaarchCourrier/
COPY --chown=www-data:www-data src/app /var/www/html/MaarchCourrier/src/app
COPY --chown=www-data:www-data src/core /var/www/html/MaarchCourrier/src/core
COPY --chown=www-data:www-data src/backend /var/www/html/MaarchCourrier/src/backend
COPY --chown=www-data:www-data src/lang /var/www/html/MaarchCourrier/src/lang

# Correct permissions
RUN mkdir /var/www/html/MaarchCourrier/custom && chown -R www-data:www-data /var/www/html/MaarchCourrier/custom

RUN find /var/www/html/MaarchCourrier -type d -exec chmod 770 {} + \
    & find /var/www/html/MaarchCourrier -type f -exec chmod 660 {} + \
    & chmod 770 /opt/maarch/docservers \
    & chmod 440 /usr/local/etc/php/php.ini \
    & wait

# Set default entrypoint
COPY --chown=root:www-data container/entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/usr/local/bin/apache2-foreground"]
