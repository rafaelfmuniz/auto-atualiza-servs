#!/bin/bash

# Variáveis personalizáveis
SCRIPT_DIR="/opt/scripts"
UPDATE_SCRIPT="update.sh"
CRON_FILE="/etc/cron.d/auto_update"
LOG_FILE="$SCRIPT_DIR/install.log"
UPDATE_SCRIPT_URL="https://raw.githubusercontent.com/rafaelfmuniz/auto-atualiza-servs/main/update.sh"
SCRIPT_VERSION="1.0"

# Habilita a interrupção do script em caso de erro
set -e

# Funções
download_script() {
    local url="$1"
    local dest="$2"
    curl -sL "$url" > "$dest" || {
        echo "Erro ao baixar $url: $?" >> "$LOG_FILE"
        exit 1
    }
}

install_script() {
    # Verifica se o script foi baixado com sucesso
    if [ ! -f "$SCRIPT_DIR/$UPDATE_SCRIPT" ]; then
        echo "Erro: O script de atualização não foi baixado corretamente." >> "$LOG_FILE"
        exit 1
    fi

    # Copia o script para o diretório de destino
    cp "$SCRIPT_DIR/$UPDATE_SCRIPT" "$SCRIPT_DIR" || {
        echo "Erro ao copiar o script de atualização: $?" >> "$LOG_FILE"
        exit 1
    }

    # Configura as permissões de execução
    chmod +x "$SCRIPT_DIR/$UPDATE_SCRIPT" || {
        echo "Erro ao configurar permissões: $?" >> "$LOG_FILE"
        exit 1
    }

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
    chmod 600 "$CRON_FILE" || {
        echo "Erro ao configurar permissões do arquivo cron: $?" >> "$LOG_FILE"
        exit 1
    }
}

# Inicio da instalação
echo "$(date +'%Y-%m-%d %H:%M:%S') Iniciando a instalação do script de atualização (versão $SCRIPT_VERSION)" >> "$LOG_FILE"

# Baixa o script de atualização
download_script "$UPDATE_SCRIPT_URL" "$SCRIPT_DIR/$UPDATE_SCRIPT"

# Instala o script e configura o cron
install_script
configure_cron

# Mensagem de conclusão
echo "$(date +'%Y-%m-%d %H:%M:%S') Instalação concluída com sucesso." >> "$LOG_FILE"
echo "Para verificar os logs: tail -f $LOG_FILE"
echo "Para desinstalar: sudo bash $SCRIPT_DIR/uninstall.sh"
