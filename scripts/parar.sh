#!/bin/bash
set -e

echo "=== Parando Plataforma de Auditoria Médica ==="
echo ""

echo "[1/3] Parando Frontend..."
docker compose -f frontend/docker-compose.yml down

echo "[2/3] Parando Backend..."
docker compose -f backend/docker-compose.yml down

echo "[3/3] Parando PostgreSQL e Redis..."
docker compose -f database/docker-compose.yml down
docker compose -f database/docker-compose.redis.yml down

echo ""
echo "=== Todos os serviços foram parados ==="
