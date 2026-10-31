#!/usr/bin/env bash
# Interactive Minecraft server console (via rcon-cli)

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

if ! vm_is_running; then
  log_error "Lima VM '${LIMA_INSTANCE}' is not running. Run 'mise run up' first."
  exit 1
fi

if [[ $# -gt 0 ]]; then
  # One-shot command execution
  vm_exec docker exec mc-server rcon-cli "$@"
else
  # Interactive console
  log_info "Connecting to Minecraft server console (Type 'quit' or press Ctrl+C to exit)..."
  vm_exec docker exec -it mc-server rcon-cli
fi
