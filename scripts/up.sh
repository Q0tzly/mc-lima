#!/usr/bin/env bash
# Start Lima VM and Minecraft Server container

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

"${SCRIPT_DIR}/init.sh"

log_info "Checking Lima VM '${LIMA_INSTANCE}' status..."

if ! vm_exists; then
  log_info "Creating and starting Lima VM '${LIMA_INSTANCE}'..."
  limactl start --name="${LIMA_INSTANCE}" --tty=false "${PROJECT_ROOT}/lima/mc-lima.yaml"
elif ! vm_is_running; then
  log_info "Starting existing Lima VM '${LIMA_INSTANCE}'..."
  limactl start "${LIMA_INSTANCE}"
else
  log_info "Lima VM '${LIMA_INSTANCE}' is already running."
fi

log_info "Starting Minecraft Server container inside Lima VM..."

# Get host UID and GID to preserve file ownership
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

vm_exec env HOST_UID="${HOST_UID}" HOST_GID="${HOST_GID}" \
  docker compose --env-file "${PROJECT_ROOT}/.env" -f "${PROJECT_ROOT}/compose/docker-compose.yml" up -d

log_success "=========================================================="
log_success " Minecraft server started successfully! "
log_success " Address:    localhost:${SERVER_PORT}"
log_success " ServerType: ${SERVER_TYPE} (${SERVER_VERSION})"
log_success " Memory:     ${MEMORY}"
log_success " Logs:       Run 'mise run logs' to follow server output"
log_success " Console:    Run 'mise run console' for interactive console"
log_success "=========================================================="
