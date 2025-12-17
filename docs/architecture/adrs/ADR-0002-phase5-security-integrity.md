# ADR-0002 — Segurança e Integridade (Fase 5)

**Data:** 2025-12-16  
**Status:** Aceito  
**Contexto:** LifeOps (single-user), n8n + PostgreSQL, ledger como memória canônica

---

## Contexto
Durante a evolução da Fase 5, uma auditoria técnica apontou riscos críticos no workflow W0:
- SQL injection por interpolação de valores em query
- Payload de evento sem validação mínima
- Runbook de incidente inexistente (operação frágil sob estresse)

O sistema já possuía base sólida (Bitwarden runtime-only, ledger canônico, versionamento inicial), então as correções deveriam:
- reduzir risco sem refatoração estrutural
- manter linearidade do roadmap
- fortalecer a memória do sistema

---

## Decisões

### D1 — Inserts no ledger passam a usar parâmetros (prepared)
O node Postgres no n8n deve usar placeholders ($1..$n) e Query Parameters, proibindo concatenação/interpolação de strings na SQL.

### D2 — BUILD_EVENT passa a normalizar o payload mínimo
No workflow W0, o node BUILD_EVENT deve garantir:
- `status ∈ {ok,warn,fail}`
- `confidence ∈ [0,1]`
- `meta` como objeto JSON
- defaults canônicos para o W0 quando inputs estiverem ausentes (ex.: agent/system, action/system.healthcheck)

### D3 — Runbook mínimo de incidente é obrigatório
Criado runbook de operação mínima para restaurar serviço sem decisões ruins sob estresse.

---

## Consequências
- Redução imediata de risco (SQL injection mitigado)
- Ledger torna-se memória mais confiável e consultável
- Operação mais segura (menos improviso)

---

## Não-Decisões (postergadas conscientemente)
- TLS/HTTPS e reverse proxy
- Rate limiting
- Observabilidade avançada (stack completa)
- Multiambiente (dev/staging/prod)

Motivo: escopo atual single-user/local e foco em construir capacidades na ordem correta.
