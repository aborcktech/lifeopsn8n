Objetivo
Restaurar a operação básica do sistema LifeOps (n8n + PostgreSQL) de forma segura, previsível e sem causar dano colateral.
Este runbook existe para ser usado quando você estiver cansado, sob pressão ou fora do horário normal de trabalho.

Escopo
Este runbook cobre apenas incidentes operacionais simples.
Não cobre:
- refatorações
- otimizações
- mudanças estruturais
- correções “aproveitando o momento”

Sintomas Comuns

S1 — n8n não inicia
- UI não carrega na porta 15678
- Container n8n em loop de restart
- Erro de autenticação ou inicialização nos logs

S2 — Workflow executa mas não grava no Ledger
- Node Postgres falha
- Nenhum novo registro em ledger.events
- Workflow termina com status failed

Verificações Rápidas
Sempre execute nesta ordem.

V1 — Containers estão rodando?
docker compose ps

V2 — Logs básicos
docker compose logs --tail=50 postgres
docker compose logs --tail=50 n8n

V3 — PostgreSQL responde?
psql -h localhost -p 15432 -U lifeops -d lifeops

Testes:
SELECT now();
SELECT count(*) FROM ledger.events;

Ações Seguras

A1 — Reiniciar serviços
docker compose restart postgres
docker compose restart n8n

A2 — Reexecutar workflow manualmente
Abrir UI do n8n
Executar W0_SYSTEM_HEALTHCHECK
Verificar novo evento no ledger

Quando Parar e Investigar
Pare se:
- Eventos duplicados
- Erros de schema/migration
- Postgres não saudável
- Indícios de corrupção

Regra de Ouro
Restaurar o serviço é prioridade absoluta.
Melhorias e refatorações nunca durante incidentes.