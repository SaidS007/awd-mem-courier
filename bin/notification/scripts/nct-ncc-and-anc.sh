#!/bin/sh
eventStackPath='/var/www/mem_courrier/bin/notification/process_event_stack.php' # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n NCC # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n ANC # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n AND # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n RED # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
