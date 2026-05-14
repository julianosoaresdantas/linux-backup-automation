#!/bin/bash
BASE_DIR="/app"
LOG_FILE="$BASE_DIR/logs/system.log"
BACKUP_DIR="$BASE_DIR/backups"
DATA=$(date +%Y%m%d_%H%M)

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

if [ -f "$LOG_FILE" ]; then
    tar -czf "$BACKUP_DIR/backup_$DATA.tar.gz" -C "$BASE_DIR/logs" system.log
    echo "[BACKUP] Criado com sucesso: backup_$DATA.tar.gz"
else
    echo "[ERRO] Log nao encontrado para backup."
    exit 1
fi
