#!/usr/bin/env bash
# Show status of Lima VM and Minecraft Server

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

SERVER_PORT="${SERVER_PORT:-25565}"

# Detect host LAN IP
default_if="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
LAN_IP=""
if [[ -n "${default_if}" ]]; then
  LAN_IP="$(ipconfig getifaddr "${default_if}" 2>/dev/null || true)"
fi

echo ""
echo "=========================================================="
echo "                 mc-lima Status Overview                  "
echo "=========================================================="

echo ""
echo "[Connection Addresses]"
if nc -z 127.0.0.1 "${SERVER_PORT}" 2>/dev/null; then
  printf "  This PC:      \033[1;32m127.0.0.1:%s\033[0m (Online & Ready)\n" "${SERVER_PORT}"
  if [[ -n "${LAN_IP}" ]]; then
    printf "  Same Wi-Fi:   \033[1;36m%s:%s\033[0m (For LAN / other devices)\n" "${LAN_IP}" "${SERVER_PORT}"
  fi
else
  printf "  This PC:      127.0.0.1:%s \033[1;31m(Server is offline or starting)\033[0m\n" "${SERVER_PORT}"
  if [[ -n "${LAN_IP}" ]]; then
    printf "  Same Wi-Fi:   %s:%s\n" "${LAN_IP}" "${SERVER_PORT}"
  fi
fi

echo ""
echo "[Server Info]"
echo "  Server Type:  ${SERVER_TYPE} (${SERVER_VERSION})"
echo "  Memory:       ${MEMORY}"
echo "  Online Mode:  ${ONLINE_MODE:-TRUE}"
echo "  Difficulty:   ${DIFFICULTY:-normal}"

if vm_is_running; then
  # Try to query online players via RCON
  ONLINE_PLAYERS="$("${SCRIPT_DIR}/rcon.sh" "list" 2>/dev/null || true)"
  if [[ -n "${ONLINE_PLAYERS}" ]]; then
    echo "  Players:      ${ONLINE_PLAYERS}"
  fi
fi

echo ""
echo "[Lima VM & Container]"
if ! vm_exists; then
  echo "  Lima VM:      Not Created (run 'mise run up' to create)"
elif vm_is_running; then
  echo "  Lima VM:      Running"
  limactl list "${LIMA_INSTANCE}"
else
  echo "  Lima VM:      Stopped"
fi

if vm_is_running; then
  echo ""
  echo "  Container Status:"
  vm_exec docker compose --env-file "${PROJECT_ROOT}/.env" -f "${PROJECT_ROOT}/compose/docker-compose.yml" ps
fi

echo "=========================================================="
echo ""
