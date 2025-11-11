#!/bin/sh
apt-get update && apt install jq -y

echo "[{\"id\":\"maarch_courrier\",\"uri\":\"courrier.local\",\"path\":null}]" > /var/www/html/MaarchCourrier/custom/custom.json

mkdir -p /var/www/html/MaarchCourrier/custom/maarch_courrier/config
mkdir -p /var/www/html/MaarchCourrier/custom/maarch_courrier/img

cp /var/www/html/MaarchCourrier/config/config.json.default /var/www/html/MaarchCourrier/custom/maarch_courrier/config/config.json
cp /var/www/html/MaarchCourrier/dist/assets/bodylogin.jpg /var/www/html/MaarchCourrier/custom/maarch_courrier/img/bodylogin.jpg

cd /var/www/html/MaarchCourrier/custom/maarch_courrier/config/
cp config.json temp
jq -r '.config.maarchUrl |= "https://courrier.local"' temp > config.json
rm temp
cp config.json temp
jq -r '.config.customID |= "maarch_courrier"' temp > config.json
rm temp
cp config.json temp
jq -r '.config.privateKeyPath |= "custom/maarch_courrier/config/mc_secret.key"' temp > config.json
rm temp
cp config.json temp
jq -r '.database[0].server |= "db-mc"' temp > config.json
rm temp

touch /var/www/html/MaarchCourrier/custom/maarch_courrier/config/mc_secret.key
echo $(cat /proc/sys/kernel/random/uuid) > /var/www/html/MaarchCourrier/custom/maarch_courrier/config/mc_secret.key
mkdir -p /opt/maarch/docservers/maarch_courrier/acknowledgement_receipts
mkdir -p /opt/maarch/docservers/maarch_courrier/ai
mkdir -p /opt/maarch/docservers/maarch_courrier/archive_transfer
mkdir -p /opt/maarch/docservers/maarch_courrier/attachments
mkdir -p /opt/maarch/docservers/maarch_courrier/convert_attachments
mkdir -p /opt/maarch/docservers/maarch_courrier/fulltext_attachments
mkdir -p /opt/maarch/docservers/maarch_courrier/fulltext_attachments
mkdir -p /opt/maarch/docservers/maarch_courrier/convert_resources
mkdir -p /opt/maarch/docservers/maarch_courrier/fulltext_attachments
mkdir -p /opt/maarch/docservers/maarch_courrier/fulltext_resources
mkdir -p /opt/maarch/docservers/maarch_courrier/migration
mkdir -p /opt/maarch/docservers/maarch_courrier/resources
mkdir -p /opt/maarch/docservers/maarch_courrier/templates
mkdir -p /opt/maarch/docservers/maarch_courrier/thumbnails_attachments
mkdir -p /opt/maarch/docservers/maarch_courrier/thumbnails_resources

cp -Rf  /var/www/html/MaarchCourrier/install/samples/templates/* /opt/maarch/docservers/maarch_courrier/templates

cd /var/www/html/MaarchCourrier

chown -R www-data:www-data /var/www/html/MaarchCourrier/custom/
chown -R www-data:www-data /opt/maarch

