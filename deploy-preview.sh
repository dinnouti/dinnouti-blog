#!/usr/bin/env bash
# Rebuilds the Hugo blog and deploys it to the Caddy-served preview path.
# No sudo required: /var/www/dinnouti-blog-preview is owned by ubuntu.
set -euo pipefail

REPO_DIR="/home/ubuntu/.hermes/cache/scratch/dinnouti-blog"
DEPLOY_DIR="/var/www/dinnouti-blog-preview"
PREVIEW_BASEURL="https://he.ls1.dinnouti.com/blog/"

cd "$REPO_DIR"
# -D: preview includes drafts. Production (GitHub Actions) builds WITHOUT -D.
hugo --minify --baseURL "$PREVIEW_BASEURL" --cleanDestinationDir -D
rsync -a --delete public/ "$DEPLOY_DIR/"
echo "Deployed to $DEPLOY_DIR -> $PREVIEW_BASEURL"
