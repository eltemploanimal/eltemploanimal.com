#!/usr/bin/env bash
# check-and-publish.sh — Cron poller for eltemploanimal.com publishing.
# Runs every 5 min. Detects new commits on origin/main and, only when there are
# any, runs publish-site.sh (pull + backup + sync). No-op when repo is in sync.
set -euo pipefail

LOG="/home/eltemploanimal/logs/publish.log"
LOCK="/home/eltemploanimal/.publish.lock"
REPO_DIR="/home/eltemploanimal/website-source"
PUBLISH="/home/eltemploanimal/publish-site.sh"

mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1

exec 9>"$LOCK"
if ! flock -n 9; then
  echo "[$(date -Is)] skipped: another publish run in progress"
  exit 0
fi

cd "$REPO_DIR"
git fetch origin -q
local_head="$(git rev-parse HEAD)"
remote_head="$(git rev-parse origin/main)"

if [ "$local_head" = "$remote_head" ]; then
  exit 0
fi

echo "[$(date -Is)] === New commits detected: $(git rev-parse --short "$local_head") -> $(git rev-parse --short "$remote_head") ==="
"$PUBLISH"
echo "[$(date -Is)] === Publish finished ==="
