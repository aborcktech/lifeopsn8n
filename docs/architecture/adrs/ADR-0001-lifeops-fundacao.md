# ADR-0001 — Fundação do LifeOps (Monorepo + n8n + Bitwarden)

## Status
Aceito

## Contexto
O LifeOps é um sistema operacional pessoal (automação + observabilidade + disciplina) que deve crescer por anos sem perder coerência.
As decisões iniciais precisam garantir: reprodutibilidade (Windows + WSL2 + Docker), segurança (segredos fora do repo), auditabilidade (histórico claro), e evolução incremental (estrutura antes de volume).

## Decisão
1) Adotar monorepo como fonte única de verdade do sistema.
2) Usar n8n como orquestrador de automações (execução e integração), mantendo a lógica de governança fora dele.
3) Usar Bitwarden (bw) como fonte de verdade para segredos, com injeção runtime-only via infra/docker/up.ps1.
4) Manter uma separação explícita por camadas:
   - infra/ (como o sistema vive)
   - n8n/ (orquestração versionada)
   - services/ (código próprio quando necessário)
   - docs/ (memória humana: ADRs + runbooks + specs)
   - data/ (runtime local: logs/backups; não versionar)

## Alternativas consideradas
- Multirepo
- Segredos em .env local
- Orquestração apenas com scripts
- Orquestração apenas com código (API/worker)

## Consequências
### Positivas
- Reprodutibilidade e governança desde o dia 1.
- Segredos centralizados e fora do controle de versão.
- Histórico claro do sistema.

### Trade-offs
- Dependência de autenticação no Bitwarden para subir o ambiente.
- Necessidade de disciplina no versionamento de workflows.

## Notas de implementação
- .env.example define contrato; .env nunca é versionado.
- up.ps1 injeta segredos em runtime; nada persiste em disco.
- Workflows do n8n devem ser exportados e versionados.

