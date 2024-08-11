#!/bin/bash

# Diretórios e arquivos
SCRIPT_DIR="/opt/scripts"
UPDATE_SCRIPT="update.sh"
CRON_FILE="/etc/cron.d/auto_update"

# Remove o script e o cron
sudo rm "$SCRIPT_DIR/$UPDATE_SCRIPT"
sudo rm "$CRON_FILE"

echo "Script de atualização desinstalado com sucesso."
