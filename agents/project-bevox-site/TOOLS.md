# TOOLS.md — Cheatsheet operacional do Bevox Site

> Onde tudo vive em `~/.openclaw/` e como invocar as CLIs principais.
> Para detalhes de cada agente/integração, ver `memory/integrations/<doc>.md`.

## Topology de ~/.openclaw/

```
~/.openclaw/
├── workspace-bevox-site/         # MEU workspace (este aqui)
├── workspace-template/         # Template canônico (referência viva)
├── kanban-tasks/               # Backend de tasks (state.json, events.jsonl, cli.sh)
│   ├── lib/                    # Python lib (project_factory, etc)
│   ├── tests/                  # pytest suite
│   └── templates/              # Templates pro factory (PRD stub, README stub)
├── dispatcher-agent/           # Hub L1 — dispara tasks ready
├── scrum-master-agent/         # Hub L1 — converte plans em tasks
├── clarification-agent/        # Hub L1 — canal pra input humano
├── tester-agent/               # Hub L1 — valida tasks em testing
├── scripts/                    # Helpers cross-cutting (bootstrap, init-topics, sanitize)
├── docs/superpowers/plans/     # Plans de implementação
├── projects-meta.json          # Metadata de todos os projetos (lock-protected)
└── projects-meta.json.lock     # Lock pra writes concorrentes
```

## CLIs principais

```bash
# Kanban (tasks per-project)
~/.openclaw/kanban-tasks/cli.sh task list --project bevox-site
~/.openclaw/kanban-tasks/cli.sh task add "..." --project bevox-site --sprint sprint-next
~/.openclaw/kanban-tasks/cli.sh task move <id> ready --actor bevox-site
~/.openclaw/kanban-tasks/cli.sh sprint list --project bevox-site
~/.openclaw/kanban-tasks/cli.sh project create "..." --id <slug>
~/.openclaw/kanban-tasks/cli.sh project remove <slug>

# Dispatcher
~/.openclaw/dispatcher-agent/cli.sh next --project bevox-site --dry-run
~/.openclaw/dispatcher-agent/cli.sh next --launch --project bevox-site
~/.openclaw/dispatcher-agent/cli.sh list-active --project bevox-site

# Scrum-master
~/.openclaw/scrum-master-agent/cli.sh propose --plan <plan.md> --project bevox-site
~/.openclaw/scrum-master-agent/cli.sh accept <proposal-id> --ready

# Clarification
~/.openclaw/clarification-agent/cli.sh ask --task <id> --question "..."
~/.openclaw/clarification-agent/cli.sh answer <cid> --answer "..."
~/.openclaw/clarification-agent/cli.sh list --project bevox-site --open

# Tester
~/.openclaw/tester-agent/cli.sh check <task-id>
~/.openclaw/tester-agent/cli.sh recheck <task-id>
~/.openclaw/tester-agent/cli.sh results [--all|--failed|--inconclusive]
```

## Outras tools / paths

```bash
# Plans dir
ls ~/.openclaw/docs/superpowers/plans/

# bevox-knowledge (source of truth)
ls ~/bevox-knowledge/{10_prd,30_adr,35_specs,40_roadmap}/

# Scripts úteis
~/.openclaw/scripts/bootstrap-telegram-agent.sh
~/.openclaw/scripts/init_telegram_topics.py
~/.openclaw/scripts/sanitize-workspace-snapshot.py
~/.openclaw/scripts/cron-dispatcher.sh

# Mission Control dev (Bernard ativa quando precisa)
cd ~/code/mission-control && npm run dev   # → http://localhost:3000

# gh CLI
gh auth status
gh pr create --title "..." --body "$(cat <<'EOF'\n...\nEOF\n)"
```

## Skills

Ver `AGENTS.md` seção "Skills disponíveis e como usá-las" pra lista completa
+ critério de quando invocar cada uma.

## MCP servers

Ver `memory/integrations/mcp.md` pra catálogo + pré-requisitos.

## Anti-patterns gerais

- Não rodar comandos destrutivos (`rm -rf`, `git reset --hard`, force push em main) sem aprovação explícita do Bernard
- Não esquecer de consultar `bevox-knowledge` (source of truth canônica) antes de inventar topology
- Não confundir runtime (`workspace-bevox-site/`, `kanban-tasks/state.json`) com source (`workspace-template/`, `bevox-knowledge/`)
