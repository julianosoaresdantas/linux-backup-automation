#!/bin/bash

# Configurações
LIMITE=80  # Alerta se o disco passar de 80%
ESPACO_DISCO=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

echo "--- Verificação de Recursos: $(date) ---"

if [ "$ESPACO_DISCO" -gt "$LIMITE" ]; then
    echo "ALERTA: Uso de disco em $ESPACO_DISCO%. Limpeza necessária!"
    # Aqui poderíamos disparar o script de backup/limpeza automaticamente
else
    echo "Sistema Saudável: Disco em $ESPACO_DISCO%."
fi
