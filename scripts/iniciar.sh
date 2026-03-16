#!/bin/bash
set -e

echo "=== Plataforma de Auditoria Médica ==="
echo ""

# Criar rede Docker compartilhada
echo "[1/4] Criando rede Docker compartilhada..."
docker network create auditoria-network 2>/dev/null || echo "Rede auditoria-network já existe."

# Subir banco de dados
echo "[2/4] Subindo PostgreSQL e Redis..."
docker compose -f database/docker-compose.yml up -d
docker compose -f database/docker-compose.redis.yml up -d

# Subir backend
echo "[3/4] Subindo Backend..."
docker compose -f backend/docker-compose.yml up -d

# Subir frontend
echo "[4/4] Subindo Frontend..."
docker compose -f frontend/docker-compose.yml up -d

echo ""
echo "=== Todos os serviços estão rodando ==="
echo "  Frontend:  http://localhost:3000"
echo "  Backend:   http://localhost:3001"
echo "  PostgreSQL: localhost:5432"
echo "  Redis:      localhost:6379"
echo ""
