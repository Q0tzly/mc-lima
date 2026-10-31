#!/usr/bin/env bash
# Delete the Lima VM (retaining host ./data)

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

FORCE=false
for arg in "$@"; do
  case "$arg" in
    -y|--yes)
      FORCE=true
      shift
      ;;
  esac
done

if ! vm_exists; then
  log_info "Lima VM '${LIMA_INSTANCE}' does not exist. Nothing to destroy."
  exit 0
fi

if [[ "${FORCE}" != "true" ]]; then
  echo ""
  log_warn "This will delete the Lima VM '${LIMA_INSTANCE}'."
  log_warn "Note: Your Minecraft world data in './data' will NOT be deleted."
  read -r -p "Are you sure you want to proceed? [y/N]: " response
  case "$response" in
    [yY][eE][sS]|[yY])
      ;;
    *)
      log_info "Aborted."
      exit 0
      ;;
  esac
fi

if vm_is_running; then
  log_info "Stopping server and VM..."
  "${SCRIPT_DIR}/down.sh" --keep-vm || true
  limactl stop -f "${LIMA_INSTANCE}" || true
fi

log_info "Deleting Lima VM '${LIMA_INSTANCE}'..."
limactl delete "${LIMA_INSTANCE}"

log_success "Lima VM '${LIMA_INSTANCE}' has been destroyed."
log_info "Your world data in './data' is preserved."
