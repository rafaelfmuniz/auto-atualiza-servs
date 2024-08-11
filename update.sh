#!/bin/bash

# ... (código similar ao que você já tem, com melhorias)

# Função para reiniciar o sistema
function reiniciar_sistema() {
    log "Reiniciando o sistema em 5 minutos..."
    sleep 300
    sudo reboot
}
