#!/bin/bash

# Configurações iniciais
UPDATE_SCRIPT_URL="https://raw.githubusercontent.com/rafaelfmuniz/auto-atualiza-servs/main/atualiza_e_reinicia.sh"
DEST_DIR="/opt/scripts"
LOG_DIR="/var/log/atualizacoes"
LOG_FILE="$LOG_DIR/atualizacoes.log"
PACKAGES="vim git htop"  # Lista de pacotes a serem instalados
SERVICES="apache2"  # Lista de serviços a serem gerenciados

# Funções auxiliares
function download_script() {
    local url="$1"
    local dest="$2"
    curl -sL "$url" > "$dest" 2>&1 | tee -a "$LOG_FILE"
}

function create_dir() {
    local dir="$1"
    sudo mkdir -p "$dir" 2>&1 | tee -a "$LOG_FILE"
}

function install_script() {
    local script="$1"
    if [ -f "$DEST_DIR/$script" ]; then
        read -p "O arquivo $DEST_DIR/$script já existe. Deseja substituí-lo? (s/n): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            sudo cp "$script" "$DEST_DIR" 2>&1 | tee -a "$LOG_FILE"
            echo "Arquivo substituído com sucesso." | tee -a "$LOG_FILE"
        else
            echo "Substituição cancelada." | tee -a "$LOG_FILE"
        fi
    else
        sudo cp "$script" "$DEST_DIR" 2>&1 | tee -a "$LOG_FILE"
        echo "Arquivo instalado com sucesso." | tee -a "$LOG_FILE"
    fi
    sudo chmod +x "$DEST_DIR/$script" 2>&1 | tee -a "$LOG_FILE"
}

function configure_cron() {
    read -p "Digite o crontab (e.g., '0 5 * * *' para rodar diariamente às 5h): " cron_expression

    # Validação básica da expressão cron (pode ser aprimorada)
    if ! [[ "$cron_expression" =~ ^[0-5][0-9] [0-2][0-3] [0-3][0-9] [0-1][0-2] [0-7]$ ]]; then
        echo "Expressão cron inválida. Por favor, tente novamente." | tee -a "$LOG_FILE"
        return 1
    fi

    sudo crontab -l > mycron 2>/dev/null
    echo "$cron_expression /opt/scripts/atualiza_e_reinicia.sh" >> mycron
    sudo crontab mycron
    rm mycron
    echo "Crontab configurado com sucesso." | tee -a "$LOG_FILE"
}

function log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

function instalar_pacotes() {
    log "Instalando pacotes: $PACKAGES"
    sudo apt-get install -y "$PACKAGES" 2>&1 | tee -a "$LOG_FILE"
}

function gerenciar_servicos() {
    log "Reiniciando serviços: $SERVICES"
    for service in $SERVICES; do
        sudo systemctl restart "$service" 2>&1 | tee -a "$LOG_FILE"
    done
}

# Criar o diretório de logs
create_dir "$LOG_DIR"

# ... (restante do script)
