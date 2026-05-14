#!/bin/bash
BASE_DIR="/app"
LOG_FILE="$BASE_DIR/logs/system.log"

if ! command -v uptime &> /dev/null; then
    echo "[ERRO] Ferramenta uptime nao encontrada."
    exit 1
fi

CPU=$(uptime | awk -F'load average:' '{print $2}')
MEM=$(free -m | grep Mem | awk '{print $4}')

echo "$(date) [PERF] CPU Load:$CPU | Mem Livre: ${MEM}MB" >> "$LOG_FILE"
echo "Metrics coletadas com sucesso."
