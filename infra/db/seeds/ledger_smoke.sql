INSERT INTO ledger.events (agent, action, input_ref, output_ref, confidence, status, meta)
VALUES (
  'Chief',
  'ledger.smoke',
  'phase:3.5',
  'db:validated',
  1.0,
  'ok',
  '{"phase":"3.5","type":"smoke"}'::jsonb
);

SELECT id, ts, agent, action, status
FROM ledger.events
ORDER BY ts DESC
LIMIT 3;
