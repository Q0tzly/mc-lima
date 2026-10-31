#!/usr/bin/env bash
# Open an interactive shell inside the Lima VM

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

if ! vm_is_running; then
  log_error "Lima VM '${LIMA_INSTANCE}' is not running. Run 'mise run up' first."
  exit 1
fi

log_info "Entering Lima VM '${LIMA_INSTANCE}' shell..."
limactl shell "${LIMA_INSTANCE}" "$@"
