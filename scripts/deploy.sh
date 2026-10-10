#!/usr/bin/env bash
set -euo pipefail

: "${RESOURCE_GROUP:?Define RESOURCE_GROUP}"
: "${UNIQUE_SUFFIX:?Define UNIQUE_SUFFIX}"
: "${VM_ADMIN_PASSWORD:?Define VM_ADMIN_PASSWORD}"
: "${POSTGRES_ADMIN_PASSWORD:?Define POSTGRES_ADMIN_PASSWORD}"

LOCATION="${LOCATION:-chilecentral}"
DEPLOYMENT_NAME="lab2-$(date +%Y%m%d%H%M)"

az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags environment=dev owner=brandon-bernal practice=azure-lab2 managed_by=bicep cost_center=utvt

az deployment group create \
  --name "$DEPLOYMENT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --template-file main.bicep \
  --parameters \
    uniqueSuffix="$UNIQUE_SUFFIX" \
    vmAdminPassword="$VM_ADMIN_PASSWORD" \
    postgresAdminPassword="$POSTGRES_ADMIN_PASSWORD" \
  --output json

