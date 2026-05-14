# Verifica se o comando 'uptime' está disponível no sistema
if ! command -v uptime &> /dev/null; then
    echo "[ERRO] Ferramenta 'uptime' não encontrada. Instale iputils ou procps."
    exit 1
fi
