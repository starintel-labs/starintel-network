% Repo invariants (operator instructions 2026-09-19; enforced by tests).

invariant(dual_actor_cli_form).
invariant_description(dual_actor_cli_form,
    'every actor capability also runs one-shot via starnet through the same validation/transport').
invariant_test(dual_actor_cli_form, 'tests/test_cli_smoke.py').

invariant(rabbitmq_only_publishing).
invariant_description(rabbitmq_only_publishing,
    'durable topic exchange documents, routing documents.ingest.<dtype>, confirms; or offline JSONL via ValidatingPublisher').
invariant_test(rabbitmq_only_publishing, 'tests/test_rabbitmq_publish.py').

invariant(deterministic_ids).
invariant_description(deterministic_ids,
    'wireless-network keyed (bssid, ssid-normalized, source_network_id); wireless-station keyed (mac, source_device_id); _id = starintel:<dtype>:<sha256-of-key>').
invariant_test(deterministic_ids, 'tests/test_deterministic_ids.py').

invariant(hermetic_tests).
invariant_description(hermetic_tests,
    'no live network/broker in pytest: httpx.MockTransport, fake pika channel, jsonl CLI smoke').
invariant_test(hermetic_tests, 'python/tests').

% Identity details
identity_key(wireless-network, [bssid, ssid_normalized, source_network_id]).
identity_key(wireless-station, [mac, source_device_id]).
id_prefix(Id, starintel) :- atomic(Id).
deterministic_id_format('starintel:<dtype>:<sha256-hex-of-identity-key>').

% Gate commands (from python/)
gate(pytest, 'bash -c "cd python && .venv/bin/pytest -q"').
gate(ruff, 'bash -c "cd python && .venv/bin/ruff check ."').
gate(mypy, 'bash -c "cd python && .venv/bin/mypy"').
