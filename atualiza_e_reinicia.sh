#!/bin/bash

# Diretório para salvar os logs
LOG_DIR="/var/log/scripts"
# Número máximo de dias para manter os logs (ajuste conforme necessário)
MAX_LOG_DAYS=7

# Arquivo de log principal
LOG_FILE="$LOG_DIR/atualizacoes.log"

# Função para limpar os logs mais antigos
function limpar_logs() {
    find "$LOG_DIR" -type f -mtime +"$MAX_LOG_DAYS" -delete
}

# Função para registrar log com data e hora
function log() {
    local mensagem="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $mensagem" >> "$LOG_FILE"
}

# Início do script
log "Iniciando atualização e reinicialização"

# Limpa os logs mais antigos
limpar_logs

# Atualiza o sistema (substitua por pacotes específicos se necessário)
log "Atualizando o sistema..."
sudo apt-get update -q && sudo apt-get upgrade -y -q
if [ $? -ne 0 ]; then
    log "Erro ao atualizar o sistema: $(cat /var/log/apt/term.log)"
    exit 1
fi
log "Atualização concluída com sucesso."

# Reinicia o sistema (ajuste conforme necessário)
read -p "Deseja reiniciar o sistema agora? (s/n): " resposta
if [[ $resposta =~ ^[Yy]$ ]]; then
    log "Reinicializando o sistema..."
    sudo reboot
fi
