#!/bin/bash

LOCK_FILE="branch-lock.json"

if [ ! -f "$LOCK_FILE" ]; then
    echo "Criando arquivo de bloqueio..."
    echo '{"branch": "main", "locked": false}' > $LOCK_FILE
fi

echo "Status atual:"
cat $LOCK_FILE

echo "Você quer (bloquear/desbloquear) o branch? Digite sua escolha:"
read CHOICE

if [ "$CHOICE" = "bloquear" ]; then
    jq '.locked = true' $LOCK_FILE > temp.json && mv temp.json $LOCK_FILE
    echo "Branch está agora bloqueado."
elif [ "$CHOICE" = "desbloquear" ]; then
    jq '.locked = false' $LOCK_FILE > temp.json && mv temp.json $LOCK_FILE
    echo "Branch está agora desbloqueado."
else
    echo "Escolha inválida. Saindo."
fi
