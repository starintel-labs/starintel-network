# Changelog

All notable changes to this repository are documented here.  The format is
based on Keep a Changelog and this project adheres to Semantic Versioning.

## [0.1.0] - 2026-09-19

### Added

- Initial StarIntel wireless/network actor repo (operator instruction
  2026-09-19), mirroring the starintel-pro-actors anatomy.
- `starintel_network.transport`: schema boundary (bundled v0.9.0 base schema
  with dtype enum extended for `wireless-network`/`wireless-station`, plus a
  local supplemental validator implementing the pending 0.10.1 data
  contracts), deterministic identity helpers, `ValidatingPublisher`,
  RabbitMQ publisher (durable topic exchange `documents`,
  `documents.ingest.<dtype>` routing, confirms, retries), and the offline
  JSONL sink.
- `starintel_network.wigle`: WiGLE API v2 client (network/search with bbox,
  ssid, netid, onlymine; searchAfter pagination with legacy lastnetid
  fallback; network detail with query-form fallback; bluetooth search),
  security-enum mapping table, wireless-network/host document builders, and
  the WiGLE actor system.
- `starintel_network.kismet`: Kismet REST client (KISMET-token cookie or
  Basic auth, `/system/status.readonly.json`, `/system/timestamp.json`,
  `POST /devices/summary|last-time` with field simplification), AP/client
  mapping to wireless-network/wireless-station, `observed_at_station`
  relations, and the timestamp-delta poller actor system.
- `starnet` CLI: every actor capability one-shot through the same
  validation and transport (`--jsonl` offline mode).
- Actor-manifest registry and document emission for `wigle` and `kismet`.
- Hermetic pytest suite (fake HTTP, fake pika channel, CLI jsonl smoke),
  ruff + mypy (strict) clean; multi-target docker/Dockerfile, compose
  service stubs, CI workflow.
- `schema/starintel-schema.lock.json` as `{"status": "pending-0.10.1"}`
  with fail-closed lock tests until the canonical 0.10.1 release lands.
