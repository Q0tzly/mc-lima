#!/usr/bin/env bash
# Execute a single Minecraft command via RCON
# Usage: mise run rcon "<command>" (e.g. mise run rcon "op Steve")

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -eq 0 ]]; then
  echo "Usage: mise run rcon <command>"
  echo "Example: mise run rcon \"say Hello Server!\""
  exit 1
fi

"${SCRIPT_DIR}/console.sh" "$@"
