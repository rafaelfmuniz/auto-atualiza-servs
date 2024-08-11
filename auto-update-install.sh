#!/bin/bash

# Configurações
UPDATE_SCRIPT_URL="https://raw.githubusercontent.com/rafaelfmuniz/auto-atualiza-servs/main/atualiza_e_reinicia.sh"
DEST_DIR="/opt/scripts"
CRON_COMMAND="0 5 * * * /opt/scripts/atualiza_e_reinicia.sh"

# Funções auxiliares
function download_script {
  local url="$1"
  local dest="$2"
  curl -sL "$url" > "$dest"
}

function create_dir {
  local dir="$1"
  mkdir -p "$dir"
}

function install_script {
  local script="$1"
  sudo cp "$script" "$DEST_DIR"
  sudo chmod +x "$DEST_DIR/$script"
}

function configure_cron {
  crontab -l > mycron
  echo "$CRON_COMMAND" >> mycron
  crontab mycron
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

echo "Script de atualização instalado e configurado para rodar via cron."
