# Definição de cores
VERDE='\033[0;32m'
VERMELHO='\033[0;31m'
NC='\033[0m' # No Color (Reseta a cor)

# Exemplo de uso no seu IF/ELSE:
if ping -c 1 "$ip" > /dev/null 2>&1; then
    echo -e "${VERDE}[OK]${NC} $nome está UP"
else
    echo -e "${VERMELHO}[ERRO]${NC} $nome está DOWN"
fi
