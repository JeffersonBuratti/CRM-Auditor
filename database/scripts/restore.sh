#!/bin/bash
# Script de restore do PostgreSQL
# Uso: ./restore.sh <arquivo_backup.dump>

if [ -z "$1" ]; then
  echo "Uso: ./restore.sh <arquivo_backup.dump>"
  exit 1
fi

CONTAINER="auditoria-postgres"
DB_USER="${POSTGRES_USER:-auditoria}"
DB_NAME="${POSTGRES_DB:-auditoria_medica}"
BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Arquivo de backup não encontrado: $BACKUP_FILE"
  exit 1
fi

echo "Iniciando restore do banco $DB_NAME a partir de $BACKUP_FILE..."
cat "$BACKUP_FILE" | docker exec -i "$CONTAINER" pg_restore -U "$DB_USER" -d "$DB_NAME" --clean --if-exists

if [ $? -eq 0 ]; then
  echo "Restore realizado com sucesso!"
else
  echo "Erro ao realizar restore!"
  exit 1
fi
