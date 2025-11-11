#!/bin/sh
eventStackPath='/var/www/mem_courrier/bin/notification/basket_event_stack.php' # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
php $eventStackPath -c /var/www/mem_courrier/config/config.json -n BASKETS # EDISSYUM - PYB01 Adaptation des chemins aux conventions Edissyum
