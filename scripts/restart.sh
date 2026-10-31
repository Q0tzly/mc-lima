#!/usr/bin/env bash
# Restart Minecraft Server container

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

if ! vm_is_running; then
  log_info "Lima VM is not running. Starting up..."
  "${SCRIPT_DIR}/up.sh"
  exit 0
fi

log_info "Restarting Minecraft Server container..."
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

vm_exec env HOST_UID="${HOST_UID}" HOST_GID="${HOST_GID}" \
  docker compose --env-file "${PROJECT_ROOT}/.env" -f "${PROJECT_ROOT}/compose/docker-compose.yml" restart

log_success "Minecraft Server restarted. Run 'mise run logs' to follow output."
