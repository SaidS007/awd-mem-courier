#!/bin/sh
emailStackPath='/var/www/mem_courrier/bin/notification/process_email_stack.php' # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $emailStackPath -c /var/www/mem_courrier/config/config.json # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
