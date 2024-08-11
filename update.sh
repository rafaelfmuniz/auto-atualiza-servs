#!/bin/bash

# Diretórios e arquivos
SCRIPT_DIR="/opt/scripts"
UPDATE_SCRIPT="update.sh"
LOG_FILE="/var/log/update.log"
HASH_FILE="sha256sum.txt"  # Arquivo com o hash SHA256 do script

# Função para registrar logs
function log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> "$LOG_FILE"
}

# Função para obter a versão do script
function get_version() {
  grep -Po 'VERSION=\K\d+\.\d+\.\d+' "$1"
}

# Função para baixar o novo script e verificar a integridade
function download_script() {
  wget -O "$UPDATE_SCRIPT.tmp" "https://meu-servidor/update.sh"
  if ! sha256sum -c "$HASH_FILE"; then
    log "Erro ao verificar a integridade do arquivo baixado."
    exit 1
  fi
  mv "$UPDATE_SCRIPT.tmp" "$SCRIPT_DIR/$UPDATE_SCRIPT"
}

# Função para atualizar o script
function update_script() {
  local new_version=$(get_version "$UPDATE_SCRIPT")
  local old_version=$(get_version "$SCRIPT_DIR/$UPDATE_SCRIPT")

  if [[ "$new_version" > "$old_version" ]]; then
    log "Nova versão disponível. Atualizando..."
    # Verificar se o arquivo já existe e fazer backup se necessário
    if [ -f "$SCRIPT_DIR/$UPDATE_SCRIPT" ]; then
      log "Fazendo backup do script existente..."
      cp "$SCRIPT_DIR/$UPDATE_SCRIPT" "$SCRIPT_DIR/$UPDATE_SCRIPT.bak"
    fi
    # Baixar e substituir o script
    download_script
  else
    log "Versão atualizada. Nada a fazer."
  fi
}

# Executar a atualização
update_script
