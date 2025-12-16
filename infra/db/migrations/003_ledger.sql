BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE SCHEMA IF NOT EXISTS ledger;

-- EVENTS
CREATE TABLE IF NOT EXISTS ledger.events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ts timestamptz NOT NULL DEFAULT now(),

  agent text NOT NULL,
  action text NOT NULL,

  input_ref text NULL,
  output_ref text NULL,

  confidence numeric(4,3) NULL CHECK (confidence >= 0 AND confidence <= 1),
  status text NOT NULL DEFAULT 'ok' CHECK (status IN ('ok','warn','fail')),

  meta jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_events_ts ON ledger.events (ts DESC);
CREATE INDEX IF NOT EXISTS idx_events_agent_ts ON ledger.events (agent, ts DESC);
CREATE INDEX IF NOT EXISTS idx_events_action_ts ON ledger.events (action, ts DESC);
CREATE INDEX IF NOT EXISTS idx_events_status_ts ON ledger.events (status, ts DESC);
CREATE INDEX IF NOT EXISTS idx_events_meta_gin ON ledger.events USING GIN (meta);

-- DECISIONS
CREATE TABLE IF NOT EXISTS ledger.decisions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ts timestamptz NOT NULL DEFAULT now(),

  topic text NOT NULL,
  options jsonb NOT NULL DEFAULT '[]'::jsonb,
  decision text NOT NULL,
  reason text NOT NULL,

  owner text NOT NULL DEFAULT 'Chief',

  meta jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_decisions_ts ON ledger.decisions (ts DESC);
CREATE INDEX IF NOT EXISTS idx_decisions_topic_ts ON ledger.decisions (topic, ts DESC);
CREATE INDEX IF NOT EXISTS idx_decisions_meta_gin ON ledger.decisions USING GIN (meta);

COMMIT;


