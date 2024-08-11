#!/bin/bash

# Diretório para salvar os logs
LOG_DIR="/var/log/scripts"

# Cria o diretório de logs se não existir
mkdir -p "$LOG_DIR"

# Arquivo de log principal
LOG_FILE="$LOG_DIR/atualizacoes.log"

# Função para limpar os logs mais antigos
function limpar_logs() {
    find "$LOG_DIR" -type f -mtime +5 -delete
}

# Data e hora atuais
DATA_HORA=$(date +"%Y-%m-%d %H:%M:%S")

# Log de início
echo "$DATA_HORA - Iniciando atualização e reinicialização" >> "$LOG_FILE"

# Limpa os logs antes de iniciar
limpar_logs

# Atualiza o sistema
sudo apt-get update && sudo apt-get upgrade -y

# Verifica se houve alguma atualização
if [ $? -eq 0 ]; then
    echo "$DATA_HORA - Atualização concluída com sucesso" >> "$LOG_FILE"
else
    echo "$DATA_HORA - Erro ao atualizar o sistema" >> "$LOG_FILE"
fi

# Reinicia o sistema
sudo reboot

# Log de finalização (não será executado após o reboot)
echo "$DATA_HORA - Reinicialização iniciada" >> "$LOG_FILE"
