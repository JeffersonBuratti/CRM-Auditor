#!/bin/bash
# Script de backup do PostgreSQL
# Uso: ./backup.sh

DATA=$(date +%Y%m%d_%H%M%S)
CONTAINER="auditoria-postgres"
DB_USER="${POSTGRES_USER:-auditoria}"
DB_NAME="${POSTGRES_DB:-auditoria_medica}"
BACKUP_DIR="$(dirname "$0")/../backups"

mkdir -p "$BACKUP_DIR"

echo "Iniciando backup do banco $DB_NAME..."
docker exec "$CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --format=custom > "$BACKUP_DIR/backup_${DATA}.dump"

if [ $? -eq 0 ]; then
  echo "Backup realizado com sucesso: $BACKUP_DIR/backup_${DATA}.dump"
else
  echo "Erro ao realizar backup!"
  exit 1
fi
