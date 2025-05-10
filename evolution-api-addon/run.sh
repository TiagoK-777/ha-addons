#!/usr/bin/env bash
set -eux

# variáveis de ambiente 
CONFIG="/data/options.json"
if [ -f "$CONFIG" ]; then
  echo "[run.sh] Carregando configuracoes de $CONFIG..."
  SERVER_TYPE=$(jq -r '.SERVER_TYPE // "http"' "$CONFIG")
  SERVER_HOST=$(jq -r '.SERVER_HOST // "homeassistant"' "$CONFIG")
  SERVER_PORT=$(jq -r '.SERVER_PORT // 49152' "$CONFIG")
  TZ=$(jq -r '.TZ // "America/Sao_Paulo"' "$CONFIG")
  DATABASE_USER=$(jq -r '.DATABASE_USER // "user"' "$CONFIG")
  DATABASE_PASSWORD=$(jq -r '.DATABASE_PASSWORD // "pass"' "$CONFIG")
  DATABASE_PROVIDER=$(jq -r '.DATABASE_PROVIDER // "postgresql"' "$CONFIG")
  DATABASE_CONNECTION_URI=$(jq -r '.DATABASE_CONNECTION_URI // "postgresql://user:pass@localhost:5432/evolution?schema=public"' "$CONFIG")
  AUTHENTICATION_API_KEY=$(jq -r '.AUTHENTICATION_API_KEY // "minha-senha-secreta"' "$CONFIG")
  
  export DATABASE_USER
  export DATABASE_PASSWORD
  export SERVER_PORT
  export SERVER_HOST
  export SERVER_TYPE
  export TZ
  export DATABASE_PROVIDER
  export DATABASE_CONNECTION_URI
  export AUTHENTICATION_API_KEY
fi

# monta e exporta o SERVER_URL
export SERVER_URL="http://${SERVER_HOST}:${SERVER_PORT}"
echo "[run.sh] Server URL set to $SERVER_URL"

# 0) Persistência em /data
mkdir -p /data/postgresql /data/redis
chown -R postgres:postgres /data/postgresql
chown -R redis:redis     /data/redis

# 1) InitDB se for primeira vez
if [ ! -f "$PGDATA/PG_VERSION" ]; then
  echo "[db] initdb (trust)..."
  su-exec postgres initdb --auth-local=trust --auth-host=trust
fi

# 2) Sockets efêmeros
mkdir -p /run/postgresql /run/redis
chown postgres:postgres /run/postgresql
chown redis:redis     /run/redis

# 3) Start Redis com persistência
echo "[redis] starting..."
su-exec redis redis-server \
  --daemonize yes \
  --dir /data/redis \
  --unixsocket /run/redis/redis.sock \
  --appendonly yes \
  --appendfilename appendonly.aof \
  --save 60 1 \
  --save 300 10 \
  --save 900 1

# 4) Start Postgres em background
echo "[db] starting..."
su-exec postgres postgres -D "$PGDATA" -c listen_addresses=localhost &

# 5) Aguarda até o Postgres aceitar conexões
for i in $(seq 1 10); do
  if psql -h localhost -U postgres -c "SELECT 1" >/dev/null 2>&1; then
    echo "[db] Postgres iniciado com sucesso!"
    break
  fi
  echo "[db] Aguardando Postgres iniciar ($i/10)..."
  sleep 2
done

# 6) Se, após o loop, ainda não conseguir conectar, aborta:
if ! psql -h localhost -U postgres -c "SELECT 1" >/dev/null 2>&1; then
  echo "[db][error] Postgres nao respondeu apos 10 tentativas, abortando..."
  exit 1
fi

# 5) Garante role “user”
psql -v ON_ERROR_STOP=1 --username postgres <<EOSQL
DO
\$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DATABASE_USER}') THEN
    EXECUTE format('CREATE ROLE %I LOGIN PASSWORD %L', '${DATABASE_USER}', '${DATABASE_PASSWORD}');
  END IF;
END
\$\$;
EOSQL

# 6) Garante DB “evolution”
if [ "$(psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='evolution'")" != "1" ]; then
  echo "[db] criando db evolution..."
  psql --username postgres -c "CREATE DATABASE evolution OWNER \"${DATABASE_USER}\";"
else
  echo "[db] evolution já existe, ignorando."
fi
psql --username postgres -c "GRANT ALL PRIVILEGES ON DATABASE evolution TO \"${DATABASE_USER}\";"

# Imprime usuário e senha do db nos logs
echo "database_user: $DATABASE_USER"
echo "database_password: $DATABASE_PASSWORD"

# Define DATABASE_CONNECTION_URI
DATABASE_CONNECTION_URI=${DATABASE_CONNECTION_URI}

# 7) Migrations e API
cd /evolution
./Docker/scripts/deploy_database.sh

echo "[app] exec Node..."
exec sh -c 'node dist/main 2>&1 | iconv -f ISO-8859-1 -t UTF-8 -c'