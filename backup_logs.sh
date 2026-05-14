# ... variáveis BASE_DIR e BACKUP_DIR definidas acima ...

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Diretório de backup não encontrado. Tentando criar..."
    mkdir -p "$BACKUP_DIR" || { echo "Erro ao criar diretório!"; exit 1; }
fi
