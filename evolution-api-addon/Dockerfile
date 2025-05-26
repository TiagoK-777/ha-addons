# syntax=docker/dockerfile:1

### Estágio 1: Configuração da Imagem Base e Variáveis de Ambiente ###

# Imagem oficial da Evolution API como base.
FROM atendai/evolution-api:v2.2.3

# Define variáveis de ambiente essenciais para o ambiente Docker e Home Assistant Add-on.
ENV TZ=America/Sao_Paulo \
    DOCKER_ENV=true \
    REDIS_URL=redis://localhost:6379 \
    WORKDIR=/evolution

### Estágio 2: Instalação de Dependências Adicionais e Configurações Essenciais ###

# Atualiza os pacotes e instala dependências adicionais como PostgreSQL, Redis e utilitários.
RUN apk update \
    && apk add --no-cache \
       postgresql17 \
       postgresql17-contrib \
       su-exec \
       redis \
       jq \
       tzdata \
       git \
       ffmpeg \
       wget \
       curl \
       bash \
       openssl \
    && rm -rf /var/cache/apk/*

# Define o diretório de trabalho.
WORKDIR /evolution

### Estágio 3: Configuração do Script de Inicialização e Ponto de Entrada ###

# Copia e concede permissões de execução ao script de inicialização principal.
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Define um HEALTHCHECK para monitorar a saúde da aplicação.
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -s http://localhost:49152/ | jq -e '.status == 200' || exit 1

# Define o ENTRYPOINT que será executado quando o contêiner iniciar.
# Este script gerencia a inicialização do Redis, PostgreSQL, migrações e a própria API.
ENTRYPOINT ["sh", "/run.sh"]