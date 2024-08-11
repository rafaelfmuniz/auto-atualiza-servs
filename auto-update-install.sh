#!/bin/bash

# Configurações iniciais
UPDATE_SCRIPT_URL="https://raw.githubusercontent.com/rafaelfmuniz/auto-atualiza-servs/main/atualiza_e_reinicia.sh"
DEST_DIR="/opt/scripts"

# Funções auxiliares
function download_script {
    local url="$1"
    local dest="$2"
    curl -sL "$url" > "$dest"
}

function create_dir {
    local dir="$1"
    sudo mkdir -p "$dir"
}

function install_script {
    local script="$1"
    if [ -f "$DEST_DIR/$script" ]; then
        read -p "O arquivo $DEST_DIR/$script já existe. Deseja substituí-lo? (s/n): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            sudo cp "$script" "$DEST_DIR"
        fi
    else
        sudo cp "$script" "$DEST_DIR"
    fi
    sudo chmod +x "$DEST_DIR/$script"
}

function configure_cron {
    read -p "Digite o crontab (e.g., '0 5 * * *' para rodar diariamente às 5h): " cron_expression
    sudo crontab -l > mycron 2>/dev/null
    echo "$cron_expression /opt/scripts/atualiza_e_reinicia.sh" >> mycron
    sudo crontab mycron
    rm mycron
}

# Criar o diretório de destino (se não existir)
create_dir "$DEST_DIR"

# Baixar o script de atualização
download_script "$UPDATE_SCRIPT_URL" "$DEST_DIR/atualiza_e_reinicia.sh"

# Instalar o script
install_script "$DEST_DIR/atualiza_e_reinicia.sh"

# Configurar o cron
configure_cron

# Informar o usuário sobre o resultado
echo "Script de atualização instalado em $DEST_DIR."
echo "O script será executado de acordo com o crontab configurado:"
echo "$cron_expression /opt/scripts/atualiza_e_reinicia.sh"
