#!/usr/bin/env bash
# Follow Minecraft Server logs

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

if ! vm_is_running; then
  log_error "Lima VM '${LIMA_INSTANCE}' is not running. Run 'mise run up' first."
  exit 1
fi

log_info "Tailing Minecraft Server logs (Press Ctrl+C to exit)..."
vm_exec docker compose --env-file "${PROJECT_ROOT}/.env" -f "${PROJECT_ROOT}/compose/docker-compose.yml" logs -f "$@"
