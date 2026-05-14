#!/bin/bash

# 1. TRÍADE DE SEGURANÇA (Strict Mode)
set -euo pipefail

# 2. VARIÁVEIS DE AMBIENTE (Portabilidade e Escalabilidade)
readonly BASE_DIR=$(cd "$(dirname "$0")/.." && pwd)
readonly BACKUP_DIR="$BASE_DIR/backups"
readonly LOG_DIR="$BASE_DIR/logs"
readonly CONFIG_DIR="$BASE_DIR/config"
readonly DATA=$(date +%Y%m%d_%H%M)
readonly LIMITE_DISCO_MB=1024
# Novos Alvos: Agora o script protege Logs e Configurações
readonly BACKUP_TARGETS=("$LOG_DIR" "$CONFIG_DIR")

# 3. FUNÇÃO DE NOTIFICAÇÃO (Simulação de Webhook/Monitoramento)
notify_status() {
    local status=$1
    local msg=$2
    local emoji="✅"
    [ "$status" -ne 0 ] && emoji="🚨"

    echo "----------------------------------------------------------"
    echo "[WEBHOOK] $emoji Status: $status | Mensagem: $msg"
    echo "----------------------------------------------------------"
}

# 4. FUNÇÃO DE INTEGRIDADE (Checksum SHA256)
generate_checksum() {
    local file=$1
    sha256sum "$file" > "${file}.sha256"
    echo "[OK] Checksum gerado: $(basename "${file}.sha256")"
}

# 5. ROTAÇÃO DE LOGS (Não deixa o log de execução crescer infinitamente)
rotate_execution_log() {
    local log_file="$LOG_DIR/execution.log"
    local max_size=$((1024 * 1024)) # 1MB em bytes
    
    if [ -f "$log_file" ] && [ $(stat -c%s "$log_file") -gt "$max_size" ]; then
        mv "$log_file" "${log_file}.old"
        echo "[INFO] Log de execução rotacionado (atingiu 1MB)."
    fi
}

# 6. TRAP DE LIMPEZA (Higiene de Processo)
tmp_work="/tmp/backup_work_$$"
cleanup() {
    rm -rf "$tmp_work"
}
trap cleanup EXIT

# 7. LÓGICA PRINCIPAL
main() {
    rotate_execution_log
    echo "--- Iniciando Operação [$DATA] ---"
    
    # Check de Espaço em Disco
    local espaco_livre=$(df -m "$BASE_DIR" | awk 'NR==2 {print $4}')
    if [ "$espaco_livre" -lt "$LIMITE_DISCO_MB" ]; then
        notify_status 1 "Espaço insuficiente: $espaco_livre MB disponíveis."
        exit 1
    fi

    # Garante que as pastas existam
    mkdir -p "${BACKUP_TARGETS[@]}" "$BACKUP_DIR"

    echo "[1/3] Compactando diretórios críticos (${#BACKUP_TARGETS[@]} alvos)..."
    # Compacta todos os alvos da lista BACKUP_TARGETS
    if tar -czf "$BACKUP_DIR/backup_$DATA.tar.gz" "${BACKUP_TARGETS[@]}" 2>/dev/null; then
        
        echo "[2/3] Validando integridade com SHA256..."
        generate_checksum "$BACKUP_DIR/backup_$DATA.tar.gz"
        
        echo "[3/3] Aplicando política de retenção e limpeza..."
        # Deleta .tar.gz e .sha256 com mais de 7 dias
        find "$BACKUP_DIR" \( -name "*.tar.gz" -o -name "*.sha256" \) -type f -mtime +7 -delete
        
        echo "--- Operação Concluída com Sucesso ---"
        notify_status 0 "Backup realizado com sucesso."
    else
        notify_status 1 "Falha crítica na compactação (TAR error)."
        exit 1
    fi
}

# Execução com Redirecionamento Profissional
# Tudo o que o script 'falar' vai para a tela e para o arquivo de log
main 2>&1 | tee -a "$LOG_DIR/execution.log"
