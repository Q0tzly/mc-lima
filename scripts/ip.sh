#!/usr/bin/env bash
# Show Minecraft server connection addresses for easy copy-pasting

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
echo "          Minecraft Server Connection Addresses           "
echo "=========================================================="
echo ""
echo "  [This PC (Localhost)]"
printf "    \033[1;32m127.0.0.1:%s\033[0m\n" "${SERVER_PORT}"
echo "    (Recommended for playing on this PC / server)"
echo ""
if [[ -n "${LAN_IP}" ]]; then
  echo "  [Same Wi-Fi / Local LAN]"
  printf "    \033[1;36m%s:%s\033[0m\n" "${LAN_IP}" "${SERVER_PORT}"
  echo "    (For friends or other devices on the same Wi-Fi)"
  echo ""
fi
echo "=========================================================="
echo ""
