#!/usr/bin/env bash
# Show status of Lima VM and Minecraft Server

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

echo "=========================================================="
echo "                 mc-lima Status Overview                  "
echo "=========================================================="

echo "[Lima VM]"
if ! vm_exists; then
  echo "  Status: Not Created (run 'mise run up' to create)"
elif vm_is_running; then
  echo "  Status: Running"
  limactl list "${LIMA_INSTANCE}"
else
  echo "  Status: Stopped"
  limactl list "${LIMA_INSTANCE}"
fi

echo ""
echo "[Minecraft Server Container]"
if vm_is_running; then
  vm_exec docker compose --env-file "${PROJECT_ROOT}/.env" -f "${PROJECT_ROOT}/compose/docker-compose.yml" ps
else
  echo "  VM is offline; container status unavailable."
fi

echo ""
echo "[Configuration]"
echo "  Server Type:    ${SERVER_TYPE}"
echo "  Version:        ${SERVER_VERSION}"
echo "  Memory:         ${MEMORY}"
echo "  Host Port:      ${SERVER_PORT}"
echo "  Difficulty:     ${DIFFICULTY}"
echo "  Max Players:    ${MAX_PLAYERS}"

echo ""
echo "[Connectivity]"
if nc -z 127.0.0.1 "${SERVER_PORT}" 2>/dev/null; then
  echo "  Port ${SERVER_PORT}: OPEN (ready for players at localhost:${SERVER_PORT})"
else
  echo "  Port ${SERVER_PORT}: Closed (server starting or stopped)"
fi
echo "=========================================================="
