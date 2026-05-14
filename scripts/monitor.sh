#!/bin/bash
VERDE='\033[0;32m'
VERMELHO='\033[0;31m'
NC='\033[0m'

BASE_DIR="/app"
INPUT="$BASE_DIR/config/inventario.txt"
LOG_FILE="$BASE_DIR/logs/system.log"

if [ ! -f "$INPUT" ]; then
    echo -e "${VERMELHO}[ERRO]${NC} Inventario nao encontrado!"
    exit 1
fi
while IFS=',' read -r nome ip descricao; do
    # Remove espaços em branco extras, se houver
    ip=$(echo $ip | tr -d ' ')
    
    if ping -c 1 "$ip" > /dev/null 2>&1; then
        echo -e "${VERDE}[OK]${NC} $nome ($ip) esta UP"
        echo "$(date) [OK] $nome esta UP" >> "$LOG_FILE"
    else
        echo -e "${VERMELHO}[ERRO]${NC} $nome ($ip) esta DOWN"
        echo "$(date) [ERRO] $nome esta DOWN" >> "$LOG_FILE"
    fi
done < "$INPUT"
