FROM alpine:latest

# Instala bash e ferramentas de rede
RUN apk add --no-cache bash iputils

# Cria o grupo e usuário
RUN addgroup -S monitor && adduser -S monitor -G monitor

WORKDIR /app

# Copiamos os arquivos primeiro
COPY scripts/ ./scripts/
COPY config/ ./config/

# CORREÇÃO: Damos a posse da pasta ao usuário monitor 
# E garantimos que ele pode ler/executar os scripts
RUN chown -R monitor:monitor /app && \
    chmod -R 755 /app/scripts

# Agora sim mudamos para o usuário monitor
USER monitor

# O comando padrão continua sendo o monitor.sh
CMD ["./scripts/monitor.sh"]
