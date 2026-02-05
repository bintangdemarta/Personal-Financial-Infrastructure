#!/bin/bash
# Description: Basic healthcheck helper (DB must be healthy)

set -euo pipefail

tries=60
sleep_s=2

for i in $(seq 1 $tries); do
  state=$(docker compose ps --format "{{.Name}} {{.State}}" | grep "firefly_db" || true)
  if echo "$state" | grep -qi "healthy"; then
    echo "[OK] firefly_db is healthy"
    exit 0
  fi
  echo "[WAIT] firefly_db not healthy yet ($i/$tries)"
  sleep $sleep_s
done

echo "[ERR] firefly_db did not become healthy in time"
exit 1
