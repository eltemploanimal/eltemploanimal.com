#!/usr/bin/env bash
# publish-site.sh — Publish eltemploanimal.com from the GitHub repo checkout.
# Pulls origin/main, backs up the live root, then syncs the repository's public/
# over the docroot. No --delete: the docroot keeps server tooling (icon/,
# awstats-icon/, cgi-bin/) and anything else that is not in the repository.
set -euo pipefail

REPO_DIR="/home/eltemploanimal/website-source"
SITE_ROOT="/home/eltemploanimal/public_html"
BACKUP_DIR="/home/eltemploanimal/backups"
KEEP_BACKUPS=10

cd "$REPO_DIR"

echo "[1/4] Pulling origin/main..."
git fetch origin -q
git checkout -q main
git pull --ff-only origin main

echo "[2/4] Backing up live site..."
mkdir -p "$BACKUP_DIR"
ts="$(date +%Y%m%d-%H%M%S)"
site_backup="$BACKUP_DIR/site-$ts"
rsync -a "$SITE_ROOT"/ "$site_backup"/
echo "  backup -> $site_backup"

echo "[3/4] Syncing public/ to website root (no delete)..."
rsync -a --exclude '.git' "$REPO_DIR/public"/ "$SITE_ROOT"/

echo "[4/4] Pruning old backups (keeping $KEEP_BACKUPS)..."
ls -1d "$BACKUP_DIR"/site-* 2>/dev/null | sort | head -n -"$KEEP_BACKUPS" | xargs -r rm -rf || true

echo "Done. Live revision: $(git rev-parse --short HEAD)"
