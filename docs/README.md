# 🧠 LifeOps — Sistema Operacional de Vida

LifeOps é um **Sistema Operacional de Vida**: uma arquitetura técnica e conceitual que integra **orquestração, memória auditável, decisão e disciplina operacional** para transformar processos pessoais e profissionais em um sistema vivo, treinável e evolutivo.

Este repositório **não é um conjunto de scripts**. É um **produto completo**, construído com princípios de engenharia, segurança e observabilidade desde a base.

---

## 🎯 Propósito

Criar um sistema que:

* Orquestra agentes especializados (via **n8n**)
* Registra tudo o que acontece em uma **memória canônica (Ledger)**
* Mantém **segredos fora do código** (runtime-only)
* Evolui por **decisões explícitas** (ADRs)
* É operável, auditável e versionável

> **Se não logou, não aconteceu.**

---

## 🧱 Arquitetura Geral

**Componentes centrais**:

* **Docker + WSL2** — ambiente reprodutível
* **n8n** — orquestrador de agentes
* **PostgreSQL** — estado, auditoria e memória
* **Ledger** — fonte da verdade (`events`, `decisions`)
* **Bitwarden** — segredos (runtime-only)

Fluxo base:

```
Trigger → Orquestração (n8n) → Ação/Interpretação → Ledger (Postgres) → Decisão
```

---

## 📁 Estrutura do Repositório

```
lifeops/
├─ infra/
│  ├─ docker/
│  │  ├─ docker-compose.yml
│  │  ├─ up.ps1
│  │  └─ .env.example
│  └─ db/
│     └─ migrations/
├─ n8n/
│  └─ workflows/
├─ docs/
│  ├─ architecture/
│  ├─ agent-specs/
│  └─ runbooks/
├─ services/
├─ data/
└─ README.md
```

---

## 🔐 Segurança (Princípio Fundamental)

* **Nenhum segredo vive no repositório**
* `.env` contém apenas configurações não sensíveis
* Segredos são injetados **em runtime** via Bitwarden CLI
* `up.ps1` é o ritual de subida segura

Isso permite:

* Repo público sem risco
* Reprodução local/VPS idêntica
* Rotação de segredos sem tocar no código

---

## 🧠 Ledger — Memória Canônica

Tudo o que acontece no LifeOps vira dado.

### `ledger.events`

* `id` (uuid)
* `ts`
* `agent`
* `action`
* `input_ref`
* `output_ref`
* `confidence` (0–1)
* `status` (ok/warn/fail)
* `meta` (jsonb)

### `ledger.decisions`

* `id`, `ts`
* `topic`
* `options` (jsonb)
* `decision`
* `reason`
* `owner`

O Ledger garante **auditabilidade, aprendizado e evolução sistêmica**.

---

## 🧪 Workflow Canônico (W0)

O sistema possui um **workflow mínimo obrigatório**:

**W0 — System Healthcheck**

* Executa periodicamente
* Testa Postgres
* Registra evento `system.healthcheck` no Ledger
* Mantém o “batimento cardíaco” do sistema

Esse workflow é:

* Versionado
* Exportado
* Tratado como ativo de produto

---

## 🧩 Padrão de Agente

Todo agente LifeOps segue o mesmo esqueleto:

1. Trigger
2. Collect
3. Interpret
4. Act
5. Log + Report

Existe um contrato formal em:

```
docs/agent-specs/AGENT_TEMPLATE.md
```

Nenhum agente nasce fora desse padrão.

---
