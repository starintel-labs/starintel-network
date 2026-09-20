# starintel-network

StarIntel wireless/network actor system: **WiGLE** and **Kismet** collectors
that ingest Wi-Fi/AP/client observations as canonical StarIntel documents.

Created per operator instruction 2026-09-19: *"full support wigle. Fork wigle
and make it into actor system that ingests wifi data. Make kismet actor
system. name the new wireless repo starintel-network"*.

Anatomy mirrors [starintel-pro-actors](../starintel-pro-actors) so the
actors are drop-in familiar: same asyncio actor lifecycle, same manifest
registry shape, same RabbitMQ schema-boundary transport, same hermetic fake
HTTP/broker test style, same multi-target Dockerfile + compose fleet.

## Layout

```
python/src/starintel_network/
  actor.py            asyncio actor lifecycle (ported from pro-actors)
  transport.py        schema boundary, deterministic ids, RabbitMQ/JSONL publishers
  manifests.py        ACTOR_MANIFESTS registry (wigle, kismet)
  cli.py              `starnet` console entry (every capability, one-shot)
  schemas/            bundled v0.9.0 base schema (envelope validation)
  wigle/              WiGLE API v2 client, mapping, actor system
  kismet/             Kismet REST client, mapping, poller actor system
python/tests/         hermetic pytest (fake HTTP via httpx.MockTransport,
                      fake pika channel, CLI jsonl smoke)
docker/Dockerfile     one image target per actor (wigle, kismet, manifests)
compose.yaml          service stubs + rabbitmq
schema/starintel-schema.lock.json   pending-0.10.1 (see below)
```

## Documents

New dtypes (StarIntel **0.10.1**, minted in parallel in the canonical schema
repo — supplemental validation is local until published):

- `wireless-network` — required `bssid`, `security`; enum-constrained
  `security` (open, wep, wpa-psk, wpa2-psk, wpa2-enterprise, wpa3-psk,
  wpa3-enterprise, wpa2wpa3-psk, unknown), `band` (2.4ghz/5ghz/6ghz/unknown),
  plus ssid, channel, frequency, signal, geo fields, observation counts,
  first/last seen, `source_network_id`, `vendor`, `hosted_host_id`, `qos`.
- `wireless-station` — required `mac`; `station_type`
  (station/ap/bridge/bridge-ap/unknown), `probe_ssids[]`, `last_bssid`,
  signal, packets, bytes, first/last seen, `source_device_id`.

Envelope is the v0.9 line: `_id`, `dataset`, `dtype`, `schema_version`
(`0.9.0`), `version`, `date_added`/`date_updated`, `sources[]`,
`evidence[]`, `data`.

**Deterministic identity** (at-least-once delivery dedupes downstream):

- `wireless-network` keyed on `(bssid, ssid-normalized, source_network_id)`
- `wireless-station` keyed on `(mac, source_device_id)`
- `_id = starintel:<dtype>:<sha256-of-identity-key>`

Kismet clients are additionally linked to AP networks with `relation`
documents (`predicate: observed_at_station`).

## WiGLE

Client for `api.wigle.net` v2 (HTTP Basic: API name + token).  Capabilities:
`network/search` (bbox `latrange1/2` + `longrange1/2`, `ssid`, `netid`,
`onlymine`; pagination via `searchAfter`, legacy `lastnetid` fallback),
network detail (`/api/v2/network/{netid}` with query-form fallback), and
`bluetooth/search`.  WiGLE throttles daily queries per account; the client
caps `resultsPerPage` at 100 (site-auth bound) and sleeps between pages.

Security mapping table (WiGLE `encryption` + `wep` flag → StarIntel enum) is
documented and exhaustively tested in `wigle/mapping.py`; the API cannot
distinguish PSK from enterprise, so plain WPA2/WPA3 map to `-psk` variants.

## Kismet

Client for the Kismet REST API (token via `KISMET` cookie, or user/pass
Basic auth).  The poller sweeps `POST /devices/last-time/{ts}/devices.json`
with field simplification (including the `a.b/c.d` union syntax), diffs by
deterministic `_id`, and emits `wireless-network` docs for AP advertised
SSIDs, `wireless-station` docs for every device, and `observed_at_station`
relations for clients whose `last_bssid` matches a swept AP.  Poll interval
is configurable; the cursor advances via `/system/timestamp.json`.

## CLI

`starnet` exposes every actor capability one-shot through the same
validation + transport as the actor path (`--jsonl` for the offline sink):

```
starnet wigle search --bbox "37.0,-96.0,38.0,-95.0" --jsonl out.jsonl
starnet wigle search --ssid "CoffeeShop" --onlymine
starnet wigle detail --netid 0A:2C:EF:3D:25:1B
starnet wigle bluetooth --bbox ... --name "Beat"
starnet kismet poll --url http://kismet:2501 --interval 30   # or --once
starnet kismet status --url http://kismet:2501
starnet manifests [--jsonl out.jsonl]
```

Env: `STARINTEL_RABBITMQ_URL` (alias `STARINTEL_RABBIT_URL`),
`STARINTEL_RABBITMQ_EXCHANGE`, `STARINTEL_DATASET`,
`STARINTEL_WIGLE_API_NAME`/`STARINTEL_WIGLE_API_TOKEN`,
`STARINTEL_KISMET_URL`, `KISMET_TOKEN`/`KISMET_USER`/`KISMET_PASSWORD`.

## Schema lock (pending)

`schema/starintel-schema.lock.json` is currently
`{"status": "pending-0.10.1"}`: the wireless dtypes are being minted in the
canonical schema repository as release 0.10.1 and the published
`starintel-doc` package does not know them yet, so this repo deliberately
does **not** pin `starintel-doc`.  Envelope validation uses the bundled
v0.9.0 base schema (dtype enum locally extended) plus a local supplemental
validator implementing the 0.10.1 data contracts.  Once the canonical
release lands: pin the lock to the canonical commit, replace the
supplemental validator with the published contracts, and restore the pin
checks in `tests/test_schema_lock.py` and CI.

## Coordination

- This repository supersedes the landing zone
  `/home/unseen/git/worktrees/starintel-pro-actors-rage-29-wigle-ingest`
  (starintel-pro-actors issue #29, WiGLE ingest).  By operator decision
  (2026-09-19) the wireless work landed here instead; **do not touch that
  worktree** — a worker was mid-flight there when this repo was created.
- Forgejo (`git.starintel.actor`, `origin`) is authoritative; GitHub is
  fallback only.  No remote is configured yet for this local-first repo.

## Development

```
cd python
python -m venv .venv && .venv/bin/pip install -e '.[dev]'
.venv/bin/pytest -q          # hermetic; no network, no broker
.venv/bin/ruff check .
.venv/bin/mypy
```
