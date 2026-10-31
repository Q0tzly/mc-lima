#!/usr/bin/env bash
# Common environment and helper functions for mc-lima scripts

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Load .env if present
if [[ -f "${PROJECT_ROOT}/.env" ]]; then
  # Export variables from .env ignoring comments
  set -a
  # shellcheck source=/dev/null
  source "${PROJECT_ROOT}/.env"
  set +a
fi

# Default configuration values
LIMA_INSTANCE="${LIMA_INSTANCE:-mc-lima}"
SERVER_TYPE="${SERVER_TYPE:-PAPER}"
SERVER_VERSION="${SERVER_VERSION:-LATEST}"
MEMORY="${MEMORY:-4G}"
SERVER_PORT="${SERVER_PORT:-25565}"
MOTD="${MOTD:-Minecraft Server on Lima}"
VM_CPUS="${VM_CPUS:-4}"
VM_MEMORY="${VM_MEMORY:-6GiB}"
VM_DISK="${VM_DISK:-30GiB}"

# Logging helpers
log_info() {
  printf "\033[1;34m[mc-lima]\033[0m %s\n" "$*"
}

log_success() {
  printf "\033[1;32m[mc-lima]\033[0m %s\n" "$*"
}

log_warn() {
  printf "\033[1;33m[mc-lima WARN]\033[0m %s\n" "$*"
}

log_error() {
  printf "\033[1;31m[mc-lima ERROR]\033[0m %s\n" "$*" >&2
}

# Check if Lima VM exists
vm_exists() {
  limactl list --quiet 2>/dev/null | grep -qx "${LIMA_INSTANCE}"
}

# Check if Lima VM is running
vm_is_running() {
  if ! vm_exists; then
    return 1
  fi
  local status
  status="$(limactl list --json 2>/dev/null | jq -r "select(.name == \"${LIMA_INSTANCE}\") | .status" 2>/dev/null || limactl list "${LIMA_INSTANCE}" --format '{{.Status}}' 2>/dev/null)"
  [[ "${status}" == "Running" ]]
}

# Run a command inside the Lima VM
vm_exec() {
  limactl shell "${LIMA_INSTANCE}" "$@"
}
