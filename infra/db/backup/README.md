# Backup do Banco — LifeOps

## Objetivo
Garantir a preservação da memória do sistema (ledger + dados operacionais).

## Escopo
- Backup manual e agendável
- Dump lógico do PostgreSQL
- Retenção local simples

## Quando executar
- Antes de mudanças estruturais
- Periodicamente (agendado no futuro)
- Antes de upgrades

## Onde salva
- Diretório: data/backups/
- Nome: lifeops_<timestamp>.sql.gz

## Garantias
- Dump consistente do banco
- Preserva ledger.events e ledger.decisions

## Fora de escopo (intencional)
- Restore automático
- Envio para cloud
- Criptografia de arquivo (por enquanto)
