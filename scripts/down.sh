#!/usr/bin/env bash
# Stop Minecraft Server and optionally shut down the Lima VM

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

KEEP_VM=false
for arg in "$@"; do
  case "$arg" in
    --keep-vm)
      KEEP_VM=true
      shift
      ;;
  esac
done

if ! vm_is_running; then
  log_info "Lima VM '${LIMA_INSTANCE}' is not running."
  exit 0
fi

log_info "Stopping Minecraft Server container (allowing world save)..."
vm_exec docker compose --env-file "${PROJECT_ROOT}/.env" -f "${PROJECT_ROOT}/compose/docker-compose.yml" stop

if [[ "${KEEP_VM}" == "true" ]]; then
  log_success "Minecraft Server stopped (Lima VM kept running)."
else
  log_info "Stopping Lima VM '${LIMA_INSTANCE}' to release system resources..."
  limactl stop "${LIMA_INSTANCE}"
  log_success "Minecraft Server and Lima VM stopped cleanly."
fi
