# syntax=docker/dockerfile:1.7
# StarIntel network actor images.
#
# One image target per runnable actor.  Build an individual image:
#
#   docker build --target wigle -f docker/Dockerfile .
#
# or use compose.yaml, which maps every service to its target below.

ARG PYTHON_VERSION=3.12-slim

# ---------------------------------------------------------------- build stage
FROM python:${PYTHON_VERSION} AS wheel-build
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /build
COPY python/pyproject.toml python/README.md ./python/
COPY python/src ./python/src
# Builds the package wheel and wheels every dependency into /dist for a
# deterministic --no-index install.
RUN python -m pip install --quiet build \
 && python -m pip wheel --wheel-dir /dist ./python

# -------------------------------------------------------------- runtime base
FROM python:${PYTHON_VERSION} AS runtime-base
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
RUN groupadd --system --gid 10001 starintel \
 && useradd --system --uid 10001 --gid starintel --home-dir /var/lib/starintel --create-home starintel
COPY --from=wheel-build /dist/ /wheels/
RUN python -m pip install --no-cache-dir --no-index /wheels/starintel_network-*.whl \
 && python -m pip install --no-cache-dir --no-index $(ls -d /wheels/* | grep -v '/starintel_network-') \
 && rm -rf /wheels
WORKDIR /var/lib/starintel
USER starintel
STOPSIGNAL SIGTERM

# -------------------------------------------------------- actor image targets
# WiGLE is a one-shot/queue-driven collector: default to a search that
# requires arguments (see compose.yaml batch profile).
FROM runtime-base AS wigle
ENTRYPOINT ["starnet", "wigle"]

# Kismet is a continuous collector: poll loop with configurable interval.
FROM runtime-base AS kismet
ENTRYPOINT ["starnet", "kismet", "poll"]

# ---------------------------------------------------------- one-shot utilities
FROM runtime-base AS actor-manifests
ENTRYPOINT ["starnet", "manifests"]
