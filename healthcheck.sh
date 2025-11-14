#!/bin/bash

# Vérifier qu'Apache fonctionne
if ! pgrep apache2 > /dev/null; then
    echo "❌ Apache ne fonctionne pas"
    exit 1
fi

# Vérifier que MEM Courrier est accessible
if curl -f http://localhost/ > /dev/null 2>&1; then
    echo "✅ MEM Courrier fonctionne correctement"
    exit 0
else
    echo "❌ Impossible d'accéder à MEM Courrier"
    exit 1
fi
