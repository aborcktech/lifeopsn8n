# Backup do Banco — LifeOps

## Objetivo
Garantir a preservação da memória do sistema LifeOps,
especialmente o ledger (`ledger.events` e `ledger.decisions`),
de forma simples, confiável e auditável.

---

## Escopo
- Backup manual do PostgreSQL
- Dump lógico em formato custom (`pg_dump -Fc`)
- Execução local, controlada pelo operador

---

## Quando Executar
- Antes de mudanças estruturais (migrations, refactors)
- Antes de upgrades de stack ou versão
- Periodicamente (agendamento futuro)
- Sempre que houver dúvida sobre integridade

---

## Onde Salva
- Diretório: `infra/db/backup/`
- Formato: `lifeops_YYYYMMDD_HHMM.dump`
- Um arquivo por execução (nunca sobrescreve)

---

## Como Executar

### Backup
```bash
./backup.sh
