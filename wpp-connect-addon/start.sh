#!/bin/sh
set -e

##############################################
###          Configuração de Shutdown      ###
##############################################

graceful_shutdown() {
    trap - TERM INT
    echo "Recebido sinal de encerramento. Parando o serviço..."
    
    # Comando mais robusto para encontrar processos filhos
    pkill -TERM -P $NODE_PID
    kill -TERM $NODE_PID 2>/dev/null
    
    # Espera com timeout ajustado
    SECONDS=5
    while kill -0 $NODE_PID 2>/dev/null; do
        if [ $SECONDS -gt 15 ]; then
            echo "Timeout - Forçando kill"
            kill -9 $NODE_PID
            break
        fi
        sleep 1
    done
    exit 143
}

# Capturar sinais de término
trap 'graceful_shutdown' SIGTERM SIGINT

##############################################
###  Carregar Variáveis de Ambiente        ###
##############################################

if [ -f /data/options.json ]; then
  # Extrair configurações do arquivo JSON
  export SERVER_PORT=$(jq -r '.SERVER_PORT // ""' /data/options.json)
  export SECRET_KEY=$(jq -r '.SECRET_KEY // ""' /data/options.json)
  export FRONTEND=$(jq -r '.FRONTEND // ""' /data/options.json)
  export START_ALL_SESSION=$(jq -r '.START_ALL_SESSION // ""' /data/options.json)
  export WEBHOOK_URL=$(jq -r '.WEBHOOK_URL // ""' /data/options.json)
  export NO_WEBHOOK_READMESSAGE=$(jq -r '.NO_WEBHOOK_READMESSAGE // ""' /data/options.json)
  export WEBHOOK_READMESSAGE=$(jq -r '.WEBHOOK_READMESSAGE // ""' /data/options.json)
  export NO_WEBHOOK_LISTENACKS=$(jq -r '.NO_WEBHOOK_LISTENACKS // ""' /data/options.json)
  export NO_WEBHOOK_ONPRESENCECHANGED=$(jq -r '.NO_WEBHOOK_ONPRESENCECHANGED // ""' /data/options.json)
  export NO_WEBHOOK_ONPARTICIPANTSCHANGED=$(jq -r '.NO_WEBHOOK_ONPARTICIPANTSCHANGED // ""' /data/options.json)
fi

##############################################
###  Preparação de Diretórios e Symlinks   ###
##############################################

mkdir -p /data/tokens /data/userDataDir
ln -sf /data/tokens /usr/src/wpp-server/tokens
ln -sf /data/userDataDir /usr/src/wpp-server/userDataDir

##############################################
###  Construção da Linha de Comando        ###
##############################################

CMD="node bin/wppserver.js"

# Adicionar parâmetros conforme configurações
[ -n "$SERVER_PORT" ] && CMD="$CMD -p $SERVER_PORT"
[ -n "$SECRET_KEY" ] && CMD="$CMD -k $SECRET_KEY"
[ "$FRONTEND" = "true" ] && CMD="$CMD --frontend"
[ "$START_ALL_SESSION" = "true" ] && CMD="$CMD --startAllSession"
[ -n "$WEBHOOK_URL" ] && CMD="$CMD --webhook-url $WEBHOOK_URL"
[ "$NO_WEBHOOK_READMESSAGE" = "true" ] && CMD="$CMD --no-webhook-readMessage"
[ "$WEBHOOK_READMESSAGE" = "true" ] && CMD="$CMD --webhook-readMessage"
[ "$NO_WEBHOOK_LISTENACKS" = "true" ] && CMD="$CMD --no-webhook-listenAcks"
[ "$NO_WEBHOOK_ONPRESENCECHANGED" = "true" ] && CMD="$CMD --no-webhook-onPresenceChanged"
[ "$NO_WEBHOOK_ONPARTICIPANTSCHANGED" = "true" ] && CMD="$CMD --no-webhook-onParticipantsChanged"

echo ""
echo " _____ _   _ _   _ _   _______ _________________  _____ _    _____ ";
echo "|_   _| | | | | | | \ | |  _  \  ___| ___ \ ___ \|  _  | |  |_   _|";
echo "  | | | |_| | | | |  \| | | | | |__ | |_/ / |_/ /| | | | |    | |  ";
echo "  | | |  _  | | | | . \` | | | |  __||    /| ___ \| | | | |    | |  ";
echo "  | | | | | | |_| | |\  | |/ /| |___| |\ \| |_/ /\ \_/ / |____| |  ";
echo "  \_/ \_| |_/\___/\_| \_/___/ \____/\_| \_\____/  \___/\_____/\_/  ";
echo "                                                                   ";
echo " ======================================================================  ";
echo "  WPPConnect - Comunicação Instantânea Poderosa                         ";
echo "  Versão 2.8.6 | Energizado para Home Assistant                          ";
echo " ======================================================================  ";
echo ""

##############################################
###  Execução da Aplicação                 ###
##############################################

# Iniciar serviço em background
exec $CMD &
NODE_PID=$!

# Manter o script ativo esperando pelo processo
wait "$NODE_PID"