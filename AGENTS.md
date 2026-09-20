# AGENTS.md — starintel-network

StarIntel wireless/network actor repo (WiGLE + Kismet → StarIntel documents).
Pattern authority: `../starintel-pro-actors` (actor lifecycle, manifests,
schema-boundary transport, test style, docker/compose).

## Hard invariants

1. **Dual actor+CLI form.** Every actor capability must also be runnable as
   a one-shot `starnet` subcommand that builds the same documents and
   validates/publishes them through the same transport. No capability may
   exist only in actor form or only in CLI form.
2. **RabbitMQ-only publishing** (durable topic exchange `documents`, routing
   key `documents.ingest.<dtype>`, publisher confirms) or the offline JSONL
   sink via the same `ValidatingPublisher` boundary. No direct HTTP ingest,
   no legacy server routes.
3. **Deterministic ids.** `wireless-network` keyed on
   `(bssid, ssid-normalized, source_network_id)`; `wireless-station` on
   `(mac, source_device_id)`; `_id = starintel:<dtype>:<sha256-of-key>`.
   Delivery is at-least-once; identity makes replays idempotent.
4. **Schema lock discipline.** `schema/starintel-schema.lock.json` is
   `{"status": "pending-0.10.1"}` until the canonical schema repo mints
   0.10.1. Envelope validation = bundled v0.9.0 base schema (dtype enum
   extended) + local supplemental validator for the wireless data contracts.
   Do NOT pin `starintel-doc` for the wireless dtypes yet. When 0.10.1
   lands: pin the lock to the canonical commit, swap the supplemental
   validator for the published contracts, and restore pin checks
   (`tests/test_schema_lock.py` fails closed on any non-pending lock).
   Never hand-edit a release bump; use the canonical repo's tooling.
5. **Hermetic tests only.** Fake HTTP (`httpx.MockTransport`), fake pika
   channels, CLI smoke in jsonl mode. No live network/broker in `pytest -q`.

## Commands (from `python/`)

```
.venv/bin/pytest -q      # all tests
.venv/bin/ruff check .
.venv/bin/mypy
```

Record gates through `prolog-verify observe` after `prolog-verify init`
(see the global agent policy). `.prolog/runs/`, `facts.kb`, `verify.pl`, and
`result.json` are local runtime state and git-ignored; `.prolog/kb/` is
tracked durable knowledge.

## Process

- Forgejo (`git.starintel.actor`) authoritative; GitHub fallback. `tea` for
  forgejo actions. This repo is currently local-only (no remote yet).
- Do NOT touch `/home/unseen/git/worktrees/starintel-pro-actors-rage-29-wigle-ingest`;
  this repo supersedes that landing zone (operator decision 2026-09-19).
- Commits: concise imperative subject, conventional style (`feat:`, `fix:`,
  `chore:`, `docs:`), no secrets, never force-push shared branches.
- Upstream API facts must be Brave-verified before coding against them;
  mark unverified field names `TODO-verify` in code comments and tests.
