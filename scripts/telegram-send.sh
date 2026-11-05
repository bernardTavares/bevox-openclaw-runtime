#!/bin/bash
# telegram-send-real.sh - Envia mensagens REAIS via Telegram usando API oficial
# Usa o mesmo bot que o OpenClaw já utiliza

set -euo pipefail

# Configurações
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:?set TELEGRAM_CHAT_ID}"
TEXT=""
PYTHON_SCRIPT="$HOME/.openclaw/telegram-send-python.py"
LOG_FILE="$HOME/.openclaw/telegram-send.log"

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
        --test)
            # Modo teste: testa conexão
            echo "🧪 Testando conexão Telegram..."
            "$PYTHON_SCRIPT" --test --text "test" 2>/dev/null
            exit $?
            ;;
        -*)
            echo "⚠️  Argumento desconhecido: $1"
            shift
            ;;
        *)
            # Primeiro argumento sem -- assume ser texto
            if [ -z "$TEXT" ]; then
                TEXT="$1"
            fi
            shift
            ;;
    esac
done

# Validações
if [ -z "$TEXT" ]; then
    echo "❌ Texto não definido. Use --text 'mensagem' ou forneça como argumento"
    echo "Uso: $0 [--chat-id ID] [--test] 'mensagem'"
    echo "Uso: $0 --text 'mensagem'"
    exit 1
fi

echo "📤 Telegram Send - Chat ID: $TELEGRAM_CHAT_ID"
echo "📝 Mensagem: ${TEXT:0:100}..."

# Verificar se script Python existe
if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "❌ Script Python não encontrado: $PYTHON_SCRIPT"
    exit 1
fi

# Verificar se token está configurado
if [ -z "${TELEGRAM_BOT_TOKEN:-}" ]; then
    echo "⚠️  Variável TELEGRAM_BOT_TOKEN não definida"
    echo "💡 O OpenClaw já tem o token configurado, mas precisa estar disponível"
    exit 1
fi

# Enviar mensagem
echo "🔄 Enviando via API Telegram..."
if "$PYTHON_SCRIPT" --chat-id "$TELEGRAM_CHAT_ID" --text "$TEXT"; then
    echo "✅ Mensagem enviada com sucesso!"
    
    # Log da operação
    echo "$(date -Iseconds)|chat_id=$TELEGRAM_CHAT_ID|text_length=${#TEXT}|status=sent" >> "$LOG_FILE"
    
    # Notificar sistema de notificações se estiver no dir bevox-mobile
    if [ -f "$HOME/.openclaw/bevox-mobile/scripts/notify.sh" ]; then
        "$HOME/.openclaw/bevox-mobile/scripts/notify.sh" "system_alert" "telegram" "Mensagem Telegram enviada: ${TEXT:0:50}..."
    fi
    
    exit 0
else
    echo "❌ Falha ao enviar mensagem"
    echo "$(date -Iseconds)|chat_id=$TELEGRAM_CHAT_ID|text_length=${#TEXT}|status=failed" >> "$LOG_FILE"
    exit 1
fi