#!/usr/bin/env bash
set -euo pipefail

: "${RESOURCE_GROUP:?Define RESOURCE_GROUP}"
: "${UNIQUE_SUFFIX:?Define UNIQUE_SUFFIX}"
: "${VM_ADMIN_PASSWORD:?Define VM_ADMIN_PASSWORD}"
: "${POSTGRES_ADMIN_PASSWORD:?Define POSTGRES_ADMIN_PASSWORD}"

az bicep build --file main.bicep --stdout >/dev/null
az deployment group validate \
  --resource-group "$RESOURCE_GROUP" \
  --template-file main.bicep \
  --parameters \
    uniqueSuffix="$UNIQUE_SUFFIX" \
    vmAdminPassword="$VM_ADMIN_PASSWORD" \
    postgresAdminPassword="$POSTGRES_ADMIN_PASSWORD" \
  --query properties.provisioningState \
  --output tsv

az deployment group what-if \
  --resource-group "$RESOURCE_GROUP" \
  --template-file main.bicep \
  --parameters \
    uniqueSuffix="$UNIQUE_SUFFIX" \
    vmAdminPassword="$VM_ADMIN_PASSWORD" \
    postgresAdminPassword="$POSTGRES_ADMIN_PASSWORD"

