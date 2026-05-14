#!/bin/bash

# Configurações
BASE_DIR="/home/juliano/projeto_admin"
LOG_FILE="$BASE_DIR/logs/system.log"
DESTINO="recrutador@empresa.com" # E-mail fictício
DATA=$(date +%d/%m/%Y)

# 1. Extrai estatísticas usando Grep e Awk
TOTAL=$(grep -c "Check" "$LOG_FILE")
ERROS=$(grep -c "DOWN" "$LOG_FILE")
OKS=$(grep -c "UP" "$LOG_FILE")

# 2. Monta o corpo do e-mail
REPORT="
Assunto: Relatório Diário de Infraestrutura - $DATA

Olá Equipe de TI,

O monitoramento automático finalizou a rodada diária.
Resultados:
- Total de verificações: $TOTAL
- Servidores ONLINE: $OKS
- Servidores OFFLINE: $ERROS

Lista de falhas detectadas:
$(grep "DOWN" "$LOG_FILE" | awk '{print "ALERTA: " $2 " está fora do ar!"}')

---
Script gerado automaticamente pelo Sistema de Monitoramento Linux-Admin-Jr.
"

# 3. Simula o envio (No terminal) ou envia via comando mail
echo "------------------------------"
echo "SIMULANDO ENVIO DE E-MAIL PARA: $DESTINO"
echo "$REPORT"
echo "------------------------------"
