#!/bin/sh
mlbStackPath='/var/www/mem_courrier/bin/notification/stack_letterbox_alerts.php' # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
eventStackPath='/var/www/mem_courrier/bin/notification/process_event_stack.php' # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $mlbStackPath   -c /var/www/mem_courrier/config/config.json # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n RET1 # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n RET2 # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
