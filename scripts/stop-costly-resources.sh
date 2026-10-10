#!/usr/bin/env bash
set -euo pipefail

: "${RESOURCE_GROUP:?Define RESOURCE_GROUP}"
: "${UNIQUE_SUFFIX:?Define UNIQUE_SUFFIX}"

az vm deallocate \
  --resource-group "$RESOURCE_GROUP" \
  --name vm-utvt-integradora-lab2-dev-clc-001 \
  --no-wait

az postgres flexible-server stop \
  --resource-group "$RESOURCE_GROUP" \
  --name "psql-utvt-integradora-lab2-${UNIQUE_SUFFIX}"

az webapp stop \
  --resource-group "$RESOURCE_GROUP" \
  --name "app-utvt-integradora-lab2-${UNIQUE_SUFFIX}"

