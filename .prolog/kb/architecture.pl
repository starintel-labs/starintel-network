% Repository architecture (verified 2026-09-19, initial build).

repo(starintel-network).
repo_purpose(starintel-network, 'wireless/network actors: WiGLE + Kismet -> StarIntel documents').
repo_pattern_authority(starintel-network, 'starintel-pro-actors').

module_role(Module, Role) :-
    module_role_(Module, Role).

module_role_('starintel_network.actor', 'asyncio actor lifecycle ported from pro-actors actor.py (pykka mailbox + manifest publication on start)').
module_role_('starintel_network.transport', 'schema boundary, deterministic identity, envelope builder, RabbitMQ/JSONL publishers').
module_role_('starintel_network.manifests', 'ACTOR_MANIFESTS registry (wigle, kismet) and actor-manifest document emission').
module_role_('starintel_network.cli', 'starnet console entry; one-shot form of every actor capability').
module_role_('starintel_network.wigle.client', 'WiGLE API v2 HTTP client (search/detail/bluetooth, pagination)').
module_role_('starintel_network.wigle.mapping', 'WiGLE result -> wireless-network/host documents; security enum mapping table').
module_role_('starintel_network.wigle.actors', 'WiGLE actor system + target param extraction').
module_role_('starintel_network.kismet.client', 'Kismet REST client (status, timestamp, device summaries)').
module_role_('starintel_network.kismet.mapping', 'Kismet device summaries -> wireless-network/station/relation documents').
module_role_('starintel_network.kismet.actors', 'timestamp-delta poller actor system with _id dedupe').

% Envelope: v0.9-line; schema_version stays 0.9.0 (base family) while the
% wireless release/profile is 0.10.1.
envelope_fields([_id, dataset, dtype, schema_version, version, date_added, date_updated, sources, evidence, data]).
envelope_schema_version('0.9.0').
