# gateway/bots/ — Multi-bot Telegram instance env files

Cada arquivo `<area>.env` corresponde a uma instância
`openclaw-gateway@<area>.service` rodando um profile openclaw isolado.

## Estrutura esperada de cada `<area>.env`

```
OPENCLAW_GATEWAY_PORT=<port-exclusivo>
# Profile: <area>. Config completa em ~/.openclaw-<area>/openclaw.json.
# Token, chat_ids, plugins, agents ficam em openclaw.json (convenção
# openclaw native, não em env file).
```

## Port allocation convention

- 18789 → Vox default (openclaw-gateway.service, sem template)
- 18790 → bevox-mobile
- 18791 → financeiro
- 18792+ → bots adicionais (marketing, bevox-backend, etc)

## Criar novo bot

```bash
~/.openclaw/scripts/bootstrap-telegram-agent.sh <area> <port>
```

Depois seguir checklist impresso pelo script.

## Audit

```bash
systemctl --user list-units 'openclaw-gateway@*' --no-pager
ls ~/.openclaw/gateway/bots/*.env
```
