#!/bin/bash

# Diretórios e arquivos
SCRIPT_DIR="/opt/scripts"
UPDATE_SCRIPT="update.sh"
CRON_FILE="/etc/cron.d/auto_update"
LOG_FILE="$SCRIPT_DIR/install.log"

# Funções auxiliares
# ... (funções semelhantes às que você já tem para baixar, criar diretório, instalar script, configurar cron)

# Verifica se o script já está instalado
if [ -f "$SCRIPT_DIR/$UPDATE_SCRIPT" ]; then
    read -p "O script de atualização já está instalado. Deseja atualizá-lo? (s/n): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        # Atualiza o script
        download_script "$UPDATE_SCRIPT_URL" "$SCRIPT_DIR/$UPDATE_SCRIPT"
        echo "Script atualizado com sucesso." >> "$LOG_FILE"
    else
        echo "Atualização cancelada." >> "$LOG_FILE"
        exit 0
    fi
fi

# Instala o script e configura o cron
install_script "$SCRIPT_DIR/$UPDATE_SCRIPT"
configure_cron

# Mensagem de conclusão
echo "Instalação concluída com sucesso." >> "$LOG_FILE"
echo "Para verificar os logs: tail -f $LOG_FILE"
echo "Para desinstalar: sudo bash $SCRIPT_DIR/uninstall.sh"
