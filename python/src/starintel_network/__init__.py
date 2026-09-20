"""StarIntel wireless/network actors: WiGLE and Kismet collectors.

Mirrors the starintel-pro-actors anatomy: an asyncio actor system
(:mod:`starintel_network.actor`), a schema boundary with RabbitMQ/JSONL
transports (:mod:`starintel_network.transport`), one actor package per
upstream source, and a ``starnet`` CLI exposing every actor capability as a
one-shot tool.
"""

from starintel_network.transport import (
    SCHEMA_VERSION,
    SchemaBoundary,
    build_envelope,
    deterministic_id,
)

__version__ = "0.1.0"

__all__ = [
    "SCHEMA_VERSION",
    "SchemaBoundary",
    "__version__",
    "build_envelope",
    "deterministic_id",
]
