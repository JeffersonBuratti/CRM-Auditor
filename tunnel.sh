#!/bin/bash

# Script para servir o frontend via Cloudflare Tunnel (URL pública temporária)
# Uso: ./tunnel.sh [porta]
# Padrão: porta 5173 (Vite dev server)

PORTA="${1:-5173}"

echo "🚀 Iniciando Cloudflare Tunnel na porta $PORTA..."
echo "⏳ Aguarde a URL pública ser gerada..."
echo ""

cloudflared tunnel --url http://localhost:$PORTA 2>&1 | while read -r line; do
  # Captura e exibe a URL pública
  if echo "$line" | grep -qoE 'https://[a-zA-Z0-9-]+\.trycloudflare\.com'; then
    URL=$(echo "$line" | grep -oE 'https://[a-zA-Z0-9-]+\.trycloudflare\.com')
    echo "============================================"
    echo "✅ URL PÚBLICA TEMPORÁRIA:"
    echo ""
    echo "   $URL"
    echo ""
    echo "============================================"
    echo ""
    echo "Pressione Ctrl+C para encerrar o tunnel."
  fi
done
