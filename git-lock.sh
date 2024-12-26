#!/bin/bash

LOCK_FILE=".branch.lock"
BRANCH=$1

if [ -z "$BRANCH" ]; then
  echo "Usage: $0 <branch-name>"
  exit 1
fi

# Função para liberar o bloqueio
release_lock() {
  if [ -f $LOCK_FILE ]; then
    rm -f $LOCK_FILE
    echo "Lock released for branch '$BRANCH'."
  fi
}

# Captura interrupções para liberar o bloqueio
trap release_lock EXIT

# Verificar se há um bloqueio
if [ -f $LOCK_FILE ]; then
  echo "Branch '$BRANCH' is locked by another process. Try again later."
  exit 1
fi

# Criar o arquivo de bloqueio
echo "$USER" > $LOCK_FILE
echo "Branch '$BRANCH' locked by $USER."

# Operações Git
echo "Checking out branch '$BRANCH'..."
git checkout $BRANCH || exit 1

echo "Pulling latest changes..."
git pull origin $BRANCH || exit 1

# Permitir ao usuário editar o código
echo "You can now make changes to the branch '$BRANCH'. Press Enter when done."
read

# Comitar e enviar alterações
echo "Committing and pushing changes..."
git add .
echo "Enter commit message:"
read COMMIT_MSG
git commit -m "$COMMIT_MSG"
git push origin $BRANCH || exit 1

# Liberar o bloqueio
release_lock
