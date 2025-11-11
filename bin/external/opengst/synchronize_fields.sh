#!/bin/sh

cd /var/www/mem_courrier/bin/external/opengst/ || exit
php OpenGSTScript.php --customId mem --action synchronize_fields
