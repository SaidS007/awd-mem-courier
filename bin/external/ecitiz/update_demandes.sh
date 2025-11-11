#!/bin/sh

cd /var/www/mem_courrier/bin/external/ecitiz/ || exit
php EcitizScript.php --customId mem --action update_demandes
