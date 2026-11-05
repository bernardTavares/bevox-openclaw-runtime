#!/bin/bash
# telegram-send.sh - Envia mensagens via Telegram usando OpenClaw Gateway ou fallback

set -euo pipefail

# Configurações
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"
TEXT=""
GATEWAY_URL="http://127.0.0.1:18789"
CONFIG_DIR="$HOME/.openclaw"

# Parse argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --chat-id)
            TELEGRAM_CHAT_ID="$2"
            shift 2
            ;;
        --text)
            TEXT="$2"
            shift 2
            ;;
        *)
            echo "⚠️  Argumento desconhecido: $1"
            shift
            ;;
    esac
done

# Validações
if [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "❌ TELEGRAM_CHAT_ID não definido. Use --chat-id ou exporte a variável."
    exit 1
fi

if [ -z "$TEXT" ]; then
    echo "❌ Texto não definido. Use --text 'mensagem'."
    exit 1
fi

echo "📤 Enviando para chat_id: $TELEGRAM_CHAT_ID"

# Tenta usar OpenClaw API se disponível
if command -v openclaw &> /dev/null; then
    echo "🔄 Tentando enviar via OpenClaw API..."
    
    # Tenta usar sessions_send se temos uma session ativa
    # Primeiro, busca sessions ativas do Telegram
    SESSIONS_RESPONSE=$(curl -s "$GATEWAY_URL/api/sessions?kind=telegram" 2>/dev/null || true)
    
    if echo "$SESSIONS_RESPONSE" | grep -q "telegram"; then
        echo "📡 Enviando via Gateway API..."
        
        # Aqui precisaríamos saber o sessionKey correto
        # Por enquanto, apenas logamos
        echo "✅ Gateway Telegram disponível (implementação em progresso)"
        echo "📝 Mensagem: $TEXT"
        
        # TODO: Implementar envio real via API quando entendermos a estrutura
        # Por enquanto, apenas echo
        echo "$TEXT"
    else
        echo "⚠️  Nenhuma session Telegram ativa encontrada"
        echo "📝 Mensagem (echo): $TEXT"
        echo "$TEXT"
    fi
else
    echo "⚠️  Comando openclaw não disponível"
    echo "📝 Mensagem (echo): $TEXT"
    echo "$TEXT"
fi

# Log da tentativa
LOG_FILE="$CONFIG_DIR/telegram-send.log"
echo "$(date -Iseconds)|chat_id=$TELEGRAM_CHAT_ID|text_length=${#TEXT}" >> "$LOG_FILE"

echo "✅ Concluído (modo echo)"