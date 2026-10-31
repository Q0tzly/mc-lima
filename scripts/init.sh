#!/usr/bin/env bash
# Initialize mc-lima configuration and directories

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

log_info "Initializing mc-lima environment..."

# Generate .env if not exists
if [[ ! -f "${PROJECT_ROOT}/.env" ]]; then
  log_info "Creating .env from .env.example..."
  cp "${PROJECT_ROOT}/.env.example" "${PROJECT_ROOT}/.env"
  log_success ".env has been created. Edit it to customize server settings."
else
  log_info ".env already exists."
fi

# Ensure data and backups directories exist
mkdir -p "${PROJECT_ROOT}/data"
mkdir -p "${PROJECT_ROOT}/backups"

log_success "Initialization complete. Run 'mise run up' to start the server."
