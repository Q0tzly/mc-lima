#!/usr/bin/env bash
# Create a timestamped backup of the Minecraft server data

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

BACKUP_DIR="${PROJECT_ROOT}/backups"
DATA_DIR="${PROJECT_ROOT}/data"
TIMESTAMP="$(date +'%Y%m%d-%H%M%S')"
BACKUP_FILE="${BACKUP_DIR}/mc-backup-${TIMESTAMP}.tar.gz"

mkdir -p "${BACKUP_DIR}"

if [[ ! -d "${DATA_DIR}" || -z "$(ls -A "${DATA_DIR}" 2>/dev/null)" ]]; then
  log_warn "Data directory '${DATA_DIR}' is empty or does not exist. Nothing to backup."
  exit 0
fi

SERVER_ACTIVE=false
if vm_is_running; then
  if vm_exec docker ps -q -f name=mc-server | grep -q .; then
    SERVER_ACTIVE=true
  fi
fi

if [[ "${SERVER_ACTIVE}" == "true" ]]; then
  log_info "Flushing world data to disk via RCON..."
  "${SCRIPT_DIR}/rcon.sh" "save-off" >/dev/null 2>&1 || true
  "${SCRIPT_DIR}/rcon.sh" "save-all flush" >/dev/null 2>&1 || true
  sleep 1
fi

log_info "Archiving '${DATA_DIR}' to '${BACKUP_FILE}'..."
tar -czf "${BACKUP_FILE}" -C "${PROJECT_ROOT}" data

if [[ "${SERVER_ACTIVE}" == "true" ]]; then
  "${SCRIPT_DIR}/rcon.sh" "save-on" >/dev/null 2>&1 || true
fi

BACKUP_SIZE="$(du -h "${BACKUP_FILE}" | cut -f1)"
log_success "Backup completed successfully!"
log_success "File: ${BACKUP_FILE} (${BACKUP_SIZE})"
