# RUNBOOK-02 — Backup e Restore do PostgreSQL

## Pré-requisitos
- Docker Compose rodando
- Container lifeops-postgres saudável
- Espaço em disco

## Backup (manual)
1. Entrar no container do Postgres
2. Executar pg_dump do database lifeops
3. Compactar o dump
4. Salvar em data/backups/

> Script oficial ficará em infra/db/backup/

## Verificação
- Arquivo .sql.gz existe
- Tamanho > 0
- Timestamp correto

## Restore (manual)
1. Subir Postgres limpo
2. Descompactar dump
3. Executar psql < dump.sql

## Validação
```sql
SELECT count(*) FROM ledger.events;
SELECT count(*) FROM ledger.decisions;
