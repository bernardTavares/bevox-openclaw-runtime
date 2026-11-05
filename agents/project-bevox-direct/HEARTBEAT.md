# HEARTBEAT.md — Voz bevox-direct

> O que checo a cada heartbeat. Manter enxuto. Cada item consome tokens.

## Checklist (a cada heartbeat)

- [ ] Tasks `ready` no kanban deste projeto sem dispatch?
      (`kanban-tasks/cli.sh task list --project bevox-direct --status ready`)
- [ ] Task `in_progress` há muito tempo sem progresso?
      (`dispatcher-agent/cli.sh list-active --project bevox-direct`)
- [ ] Tasks `blocked` (clarification não respondida) há mais de 24h?
      (`clarification-agent/cli.sh list --project bevox-direct --open`)
- [ ] Tasks em `testing` há mais de 12h sem tester ter rodado?
      (`tester-agent/cli.sh results --inconclusive`)
- [ ] Pendências abertas em `memory/pending.md`
- [ ] Telegram topics ainda funcionando (mensagens recentes batem em
      `clarifications` / `dispatcher` quando deveriam)?

## Semanal (domingo)

- [ ] Revisar sprint atual deste projeto
      (`kanban-tasks/cli.sh sprint list --project bevox-direct`)
- [ ] Consolidar notas de `memory/sessions/` em `memory/context/` ou
      `memory/projects/bevox-direct.md` se decisões importantes acumularam
- [ ] Atualizar `memory/MEMORY.md` se novos arquivos relevantes apareceram
- [ ] Verificar saúde de `bevox-knowledge` (rodar watcher do knowledge-sync)

## Regras

- Se nada precisa de atenção → reportar `HEARTBEAT_OK`
- Não inventar problemas pra parecer útil — se sprint corre bem, dizer isso
- Notificar Bernard via Telegram apenas se há ação requerida ou risco real
- Evitar notificações entre 23h e 8h, salvo urgência operacional
