#!/bin/sh

# Check if a parameter is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <customId>"
  exit 1
fi

CUSTOM_ID=$1

cd /var/www/mem_courrier/bin/external/opengst/ || exit
php OpenGSTScript.php --customId "$CUSTOM_ID" --action retrieve_signalements
