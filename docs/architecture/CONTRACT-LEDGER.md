
Cole:

```md
# Contrato Canônico do Ledger — LifeOps

## ledger.events (obrigatório)
Campos mínimos:
- agent
- action (domain.verb)
- status (ok|warn|fail)
- confidence (0–1)
- ts (auto)
- meta (jsonb)

## Convenção de action
Exemplos:
- backup.created
- system.healthcheck
- agent.pc_inventory.completed

## Regras para meta
Permitido:
- context
- source
- tags
- duration_ms
- result_summary
- references

Proibido:
- senhas
- tokens
- dumps completos
- paths sensíveis sem anonimização

## ledger.decisions
Apenas decisões explícitas, humanas ou sistêmicas.

## Regra de ouro
Se não gera aprendizado, não entra no ledger.
