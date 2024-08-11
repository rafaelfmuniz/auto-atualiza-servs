#!/bin/bash

# Diretórios e arquivos
SCRIPT_DIR="/opt/scripts"
UPDATE_SCRIPT="update.sh"
LOG_FILE="/var/log/update.log"

# Função para registrar logs
function log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> "$LOG_FILE"
}

# Função para obter a versão do script
function get_version() {
  local script="$1"
  # Assumindo que a versão está em uma linha específica com o formato "VERSION=1.2.3"
  grep -Po 'VERSION=\K\d+\.\d+\.\d+' "$script"
}

# Função para baixar o novo script
function download_script() {
  # ... código para baixar o script
  # Verificar integridade do arquivo baixado
}

# Função para atualizar o script
function update_script() {
  local new_version=$(get_version "$UPDATE_SCRIPT")
  local old_version=$(get_version "$SCRIPT_DIR/$UPDATE_SCRIPT")

  if [[ "$new_version" > "$old_version" ]]; then
    log "Nova versão disponível. Atualizando..."
    # Criar um backup (opcional)
    cp "$SCRIPT_DIR/$UPDATE_SCRIPT" "$SCRIPT_DIR/$UPDATE_SCRIPT.bak"
    # Baixar e substituir o script
    download_script
  else
    log "Versão atualizada. Nada a fazer."
  fi
}

# Função para reiniciar o sistema (com opção de confirmação)
function reiniciar_sistema() {
  read -p "Deseja reiniciar o sistema agora? (s/n): " confirm
  if [[ "$confirm" == "s" || "$confirm" == "S" ]]; then
    log "Reiniciando o sistema..."
    sudo reboot
  else
    log "Reinício cancelado."
  fi
}

# Verificar se o script está sendo executado com privilégios de root
if [[ $(id -u) != 0 ]]; then
  echo "Este script deve ser executado como root."
  exit 1
fi

# Executar as atualizações
update_script

# Verificar se o script foi atualizado com sucesso e reiniciar o sistema
if [[ $? -eq 0 ]]; then
  reiniciar_sistema
fi
