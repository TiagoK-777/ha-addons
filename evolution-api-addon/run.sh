#!/usr/bin/env bash
set -e

# -----------------------------------------------------------------------------
# Função de log
# -----------------------------------------------------------------------------
log_info() {
  echo "[INFO] $1"
}

log_error() {
  echo "[ERROR] $1"
}

# -----------------------------------------------------------------------------
# Variáveis globais para controle de PIDs
# -----------------------------------------------------------------------------
PG_PID=""
REDIS_PID=""
NODE_PID=""

# -----------------------------------------------------------------------------
# Função de limpeza (parada graciosa)
# -----------------------------------------------------------------------------
cleanup() {
  log_info "Recebendo sinal para encerrar, parando serviços..."

  # 1) Parar aplicação Node.js
  if [[ -n "${NODE_PID:-}" ]] && kill -0 "$NODE_PID" 2>/dev/null; then
    log_info "Parando aplicação Node.js..."
    kill -TERM "$NODE_PID"
    
    # Esperar até 10 segundos pelo término do Node
    for i in {1..10}; do
      if ! kill -0 "$NODE_PID" 2>/dev/null; then
        log_info "Node.js encerrado."
        break
      fi
      sleep 1
    done
    
    # Se ainda estiver em execução, force o encerramento
    if kill -0 "$NODE_PID" 2>/dev/null; then
      log_info "Forçando encerramento do Node.js..."
      kill -9 "$NODE_PID" || true
    fi
  fi

  # 2) Parar PostgreSQL usando pg_ctl
  if [[ -n "${PG_PID:-}" ]] && kill -0 "$PG_PID" 2>/dev/null; then
    log_info "Parando PostgreSQL graciosamente..."
    su-exec postgres pg_ctl -D "$PGDATA" -m fast stop
    
    # Aguardar até 15 segundos para o PostgreSQL terminar
    for i in {1..15}; do
      if ! kill -0 "$PG_PID" 2>/dev/null; then
        log_info "PostgreSQL encerrado com sucesso."
        break
      fi
      sleep 1
    done
    
    # Se ainda estiver em execução, tentar uma última vez
    if kill -0 "$PG_PID" 2>/dev/null; then
      log_info "PostgreSQL ainda em execução, enviando SIGTERM..."
      kill -TERM "$PG_PID" || true
      sleep 5
      
      # Se ainda não terminou, força o encerramento
      if kill -0 "$PG_PID" 2>/dev/null; then
        log_info "Forçando encerramento do PostgreSQL..."
        kill -9 "$PG_PID" || true
      fi
    fi
  fi

  # 3) Parar Redis
  if [[ -n "${REDIS_PID:-}" ]] && kill -0 "$REDIS_PID" 2>/dev/null; then
    log_info "Parando Redis..."
    redis-cli shutdown || true
    
    # Aguardar até 10 segundos para o Redis terminar
    for i in {1..10}; do
      if ! kill -0 "$REDIS_PID" 2>/dev/null; then
        log_info "Redis encerrado com sucesso."
        break
      fi
      sleep 1
    done
    
    # Se ainda estiver em execução, force o encerramento
    if kill -0 "$REDIS_PID" 2>/dev/null; then
      log_info "Forçando encerramento do Redis..."
      kill -9 "$REDIS_PID" || true
    fi
  fi

  log_info "Todos os serviços foram encerrados."
  exit 0
}

# -----------------------------------------------------------------------------
# Carrega as variáveis do .env, se existir
# -----------------------------------------------------------------------------
if [ -f /evolution/.env ]; then
export $(grep -v '^#' /evolution/.env | xargs)
fi

# -----------------------------------------------------------------------------
# Carregamento de configurações
# -----------------------------------------------------------------------------
log_info "Carregando configurações de /data/options.json..."
CONFIG="/data/options.json"

if [ -f "$CONFIG" ]; then
  SERVER_TYPE=$(jq -r '.SERVER_TYPE // "http"' "$CONFIG")
  SERVER_HOST=$(jq -r '.SERVER_HOST // "homeassistant"' "$CONFIG")
  SERVER_PORT=$(jq -r '.SERVER_PORT // 49152' "$CONFIG")
  TZ=$(jq -r '.TZ // "America/Sao_Paulo"' "$CONFIG")
  DATABASE_USER=$(jq -r '.DATABASE_USER // "user"' "$CONFIG")
  DATABASE_PASSWORD=$(jq -r '.DATABASE_PASSWORD // "pass"' "$CONFIG")
  DATABASE_PROVIDER=$(jq -r '.DATABASE_PROVIDER // "postgresql"' "$CONFIG")
  DATABASE_CONNECTION_URI=$(jq -r '.DATABASE_CONNECTION_URI // "postgresql://user:pass@localhost:5432/evolution?schema=public"' "$CONFIG")
  AUTHENTICATION_API_KEY=$(jq -r '.AUTHENTICATION_API_KEY // "minha-senha-secreta"' "$CONFIG")
  PERSISTENCE_DIR=$(jq -r '.PERSISTENCE_DIR // "/data"' "$CONFIG")
  
  # Carrega as variáveis definidas em CUSTOM_ENV
  CUSTOM_ENV=$(jq -r '.CUSTOM_ENV // ""' "$CONFIG")

	if [ -n "$CUSTOM_ENV" ] && [ "$CUSTOM_ENV" != "" ]; then
    log_info "Carregando variáveis personalizadas:"
    for var in $CUSTOM_ENV; do
      # Separa chave e valor
      key=$(echo "$var" | cut -d '=' -f 1)
      value=$(echo "$var" | cut -d '=' -f 2-)
      
      # Exporta a variável
      export "$key"="$value"
      echo "  - $key=$value"
    done
  fi
fi

export DATABASE_USER
export DATABASE_PASSWORD
export SERVER_PORT
export SERVER_HOST
export SERVER_TYPE
export TZ
export DATABASE_PROVIDER
export DATABASE_CONNECTION_URI
export AUTHENTICATION_API_KEY
export PERSISTENCE_DIR
export PGDATA="${PERSISTENCE_DIR}/postgresql"
export SERVER_URL="http://${SERVER_HOST}:${SERVER_PORT}"

# -----------------------------------------------------------------------------
# Variáveis carregadas
# -----------------------------------------------------------------------------
log_info "Variáveis carregadas:"
env | while read -r line; do
printf "  - %s\n" "$line"
done

# Registrar trap para SIGTERM e SIGINT
trap cleanup SIGTERM SIGINT

# -----------------------------------------------------------------------------
# Preparação de diretórios
# -----------------------------------------------------------------------------
log_info "Criando diretórios de persistência em ${PERSISTENCE_DIR}..."
mkdir -p "${PERSISTENCE_DIR}/postgresql" "${PERSISTENCE_DIR}/redis" "${PERSISTENCE_DIR}/instances" "/run/postgresql" "/run/redis"
chown -R postgres:postgres "${PERSISTENCE_DIR}/postgresql" "/run/postgresql"
chown -R redis:redis "${PERSISTENCE_DIR}/redis" "/run/redis"

ln -sf "${PERSISTENCE_DIR}/instances" "/evolution/instances"

# -----------------------------------------------------------------------------
# Migrando o database caso esteja em /data
# -----------------------------------------------------------------------------
if [[ -f "/data/postgresql/PG_VERSION" && "$PERSISTENCE_DIR" != "/data" ]]; then
    log_info "Migrando diretórios de persistência para ${PERSISTENCE_DIR}"
    if [ -f "/config/addons_config/evolution-api/postgresql/PG_VERSION" ]; then
        log_info "Removendo arquivos antigos de /config/addons_config/evolution-api"
        rm -rf "/config/addons_config/evolution-api" || { log_error "Falha ao remover arquivos de /config/addons_config/evolution-api"; }
    fi
    mkdir -p "${PERSISTENCE_DIR}"
    cp -rp "/data/postgresql" "${PERSISTENCE_DIR}/" || { log_error "Falha ao copiar postgresql"; exit 1; }
    cp -rp "/data/redis" "${PERSISTENCE_DIR}/" || { log_error "Falha ao copiar redis"; exit 1; }
    cp -rp "/data/instances" "${PERSISTENCE_DIR}/" || { log_error "Falha ao copiar instances"; exit 1; }
    rm -rf "/data/postgresql" || { log_error "Falha ao remover postgresql antigo"; exit 1; }
    rm -rf "/data/redis" || { log_error "Falha ao remover redis antigo"; exit 1; }
    rm -rf "/data/instances" || { log_error "Falha ao remover instances"; exit 1; }
    log_info "Migração concluída. Aguardando 10 segundos para estabilização..."
    sleep 10
fi

# -----------------------------------------------------------------------------
# Inicialização do PostgreSQL
# -----------------------------------------------------------------------------
# Inicialização do banco de dados, se necessário
if [ ! -f "$PGDATA/PG_VERSION" ]; then
  log_info "Inicializando banco de dados PostgreSQL..."
  su-exec postgres initdb --auth-local=trust --auth-host=trust
fi

# Verificar e remover postmaster.pid se necessário
if [ -f "$PGDATA/postmaster.pid" ]; then
  PID=$(head -1 "$PGDATA/postmaster.pid" 2>/dev/null || echo "")
  if [ -n "$PID" ] && ! ps -p "$PID" > /dev/null; then
    log_info "Removendo arquivo de PID desatualizado do PostgreSQL..."
    rm -f "$PGDATA/postmaster.pid"
  fi
fi

# -----------------------------------------------------------------------------
# Iniciar Redis
# -----------------------------------------------------------------------------
log_info "Iniciando Redis (foreground)..."
su-exec redis redis-server \
  --dir ${PERSISTENCE_DIR}/redis \
  --unixsocket /run/redis/redis.sock \
  --appendonly yes \
  --appendfilename appendonly.aof \
  --save 60 1 \
  --save 300 10 \
  --save 900 1 &
REDIS_PID=$!

# -----------------------------------------------------------------------------
# Iniciar PostgreSQL
# -----------------------------------------------------------------------------
log_info "Iniciando PostgreSQL (foreground)..."
su-exec postgres postgres -D "$PGDATA" -c listen_addresses=localhost &
PG_PID=$!

# Aguardar PostgreSQL iniciar
log_info "Aguardando PostgreSQL aceitar conexões..."
for i in $(seq 1 10); do
  log_info "Tentativa $i/10..."
  if su-exec postgres pg_isready -h localhost -U postgres > /dev/null 2>&1; then
    log_info "PostgreSQL está pronto!"
    break
  fi
  
  # Se chegamos na última tentativa e ainda não conectou, abortar
  if [ $i -eq 10 ]; then
    log_error "PostgreSQL não respondeu após 10 tentativas, abortando..."
    cleanup
    exit 1
  fi
  
  sleep 2
done

# -----------------------------------------------------------------------------
# Configurar banco de dados
# -----------------------------------------------------------------------------
# Verificar se usuário já existe
USER_EXISTS=$(su-exec postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DATABASE_USER}'")

if [ "$USER_EXISTS" != "1" ]; then
  log_info "Criando usuário ${DATABASE_USER}..."
  su-exec postgres psql -c "CREATE ROLE \"${DATABASE_USER}\" LOGIN PASSWORD '${DATABASE_PASSWORD}';"
else
  log_info "Usuário ${DATABASE_USER} já existe."
fi

# Verificar se banco de dados já existe
DB_EXISTS=$(su-exec postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='evolution'")

if [ "$DB_EXISTS" != "1" ]; then
  log_info "Criando banco de dados evolution..."
  su-exec postgres psql -c "CREATE DATABASE evolution OWNER \"${DATABASE_USER}\";"
else
  log_info "Banco de dados evolution já existe."
fi

su-exec postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE evolution TO \"${DATABASE_USER}\";"

# -----------------------------------------------------------------------------
# Executar migrations e iniciar aplicação
# -----------------------------------------------------------------------------
log_info "Executando migrations de banco de dados..."
cd /evolution
./Docker/scripts/deploy_database.sh

echo ""
echo "┌───────────────────────────────────────────────────────────────────────────────────────┐"
echo "│ Usuário do banco de dados: $DATABASE_USER"
echo "│ Senha do banco de dados: $DATABASE_PASSWORD"
echo "│ Chave de API Global: $AUTHENTICATION_API_KEY"
echo "│ URL do banco de dados: $DATABASE_CONNECTION_URI"
echo "│ URL do servidor: $SERVER_URL"
echo "│ Diretório de persistência: $PERSISTENCE_DIR"
echo "└───────────────────────────────────────────────────────────────────────────────────────┘"
echo ""

log_info "Iniciando aplicação Node.js..."
node dist/main &
NODE_PID=$!

# Aguardar por algum dos processos terminar
wait -n "$PG_PID" "$REDIS_PID" "$NODE_PID" || true

# Se chegamos aqui, um dos processos terminou
log_error "Um dos serviços terminou inesperadamente. Encerrando todos os serviços..."
cleanup
