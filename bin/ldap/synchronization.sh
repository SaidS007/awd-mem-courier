#!/bin/sh
CUSTOM=mem

cd /var/www/mem_courrier/bin/ldap/
php synchronizationScript.php --customId $CUSTOM

# EDISSYUM - PYB01 Ajout de requêtes SQL après le script de synchronisation LDAP

CONFIG_PATH="/var/www/mem_courrier/custom/$CUSTOM/config/config.json"

DB_HOST=$(jq -r '.database[0].server' $CONFIG_PATH)
DB_PORT=$(jq -r '.database[0].port' $CONFIG_PATH)
DB_NAME=$(jq -r '.database[0].name' $CONFIG_PATH)
DB_USER=$(jq -r '.database[0].user' $CONFIG_PATH)
DB_PASSWORD=$(jq -r '.database[0].password' $CONFIG_PATH)

export PGPASSWORD="$DB_PASSWORD"

PSQL_CMD="psql -h $DB_HOST -p $DB_PORT  -U $DB_USER $DB_NAME "

$PSQL_CMD <<EOR
-- Decommenter et adapter les requetes pertinentes
--UPDATE users SET status='OK' WHERE status='DEL' AND UPPER(user_id) IN (SELECT entity_id FROM entities);
EOR

# END EDISSYUM - PYB01