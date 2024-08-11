#!/bin/bash

# Diretórios e arquivos
SCRIPT_DIR="/opt/scripts"
UPDATE_SCRIPT="update.sh"
CRON_FILE="/etc/cron.d/auto_update"
LOG_FILE="$SCRIPT_DIR/install.log"
UPDATE_SCRIPT_URL="https://raw.githubusercontent.com/rafaelfmuniz/auto-atualiza-servs/main/update.sh"

# Funções
download_script() {
    local url="$1"
    local dest="$2"
    curl -sL "$url" > "$dest"
}

install_script() {
    # Verifica se o script foi baixado com sucesso
    if [ ! -f "$SCRIPT_DIR/$UPDATE_SCRIPT" ]; then
        echo "Erro: O script de atualização não foi baixado corretamente." >> "$LOG_FILE"
        exit 1
    fi

    # Copia o script para o diretório de destino
    cp "$SCRIPT_DIR/$UPDATE_SCRIPT" "$SCRIPT_DIR"

    # Configura as permissões de execução
    chmod +x "$SCRIPT_DIR/$UPDATE_SCRIPT"

    # Adiciona uma mensagem ao log
    echo "Script de atualização instalado com sucesso." >> "$LOG_FILE"
}

configure_cron() {
    # Cria o arquivo cron
    cat > "$CRON_FILE" <<EOF
# Atualiza o script a cada dia
0 0 * * * root $SCRIPT_DIR/$UPDATE_SCRIPT
EOF

    # Configura as permissões do arquivo cron
    chmod 600 "$CRON_FILE"
}

# Verifica se o script já está instalado e oferece a opção de atualização
if [ -f "$SCRIPT_DIR/$UPDATE_SCRIPT" ]; then
    read -p "O script de atualização já está instalado. Deseja atualizá-lo? (s/n): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        download_script "$UPDATE_SCRIPT_URL" "$SCRIPT_DIR/$UPDATE_SCRIPT"
        echo "Script atualizado com sucesso." >> "$LOG_FILE"
    else
        echo "Atualização cancelada." >> "$LOG_FILE"
        exit 0
    fi
fi

# Instala o script e configura o cron
install_script
configure_cron

# Mensagem de conclusão
echo "Instalação concluída com sucesso." >> "$LOG_FILE"
echo "Para verificar os logs: tail -f $LOG_FILE"
echo "Para desinstalar: sudo bash $SCRIPT_DIR/uninstall.sh"
