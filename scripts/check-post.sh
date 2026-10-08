#!/usr/bin/env bash
# Usage: scripts/check-post.sh content/posts/<slug>.md  (or content/recipes/<slug>.md)
# Template-consistency check; exits non-zero on any failure.
set -uo pipefail
cd "$(dirname "$0")/.."
f="${1:?usage: check-post.sh <content file>}"
[ -f "$f" ] || { echo "FAIL: $f not found"; exit 2; }
fail=0
bad(){ echo "FAIL: $*"; fail=1; }
ok(){ echo "ok:   $*"; }
fm=$(awk '/^---$/{c++; next} c==1' "$f")
body=$(awk '/^---$/{c++; next} c>=2' "$f")
has(){ echo "$fm" | grep -qE "^$1:"; }
type=posts; case "$f" in content/recipes/*) type=recipes;; esac
for k in title date draft; do has $k && ok "front matter: $k" || bad "missing front matter: $k"; done
if [ $type = recipes ]; then
  for k in description tags prep_time cook_time total_time servings difficulty ingredients; do
    has $k && ok "recipe field: $k" || bad "missing recipe field: $k"; done
  echo "$body" | grep -qE '^# ' && bad "recipe body has an H1"
  echo "$body" | grep -qiE '^#+ *ingredients' && bad "recipe body repeats ingredients"
  echo "$body" | grep -qE '^1\. ' && ok "numbered steps present" || bad "no numbered steps"
else
  has tags && ok "tags" || bad "missing tags"
  echo "$fm" | grep -qE '^comments: *false' && ok "comments: false" || bad "comments: false missing"
  echo "$body" | grep -qE '^# ' && bad "body has an H1 duplicating the title" || ok "no H1 in body"
fi
out=$(hugo --minify --baseURL "https://he.ls1.dinnouti.com/blog/" -D --destination /tmp/blog-check-public 2>&1)
echo "$out" | grep -qiE 'warn|error' && { bad "hugo warnings/errors:"; echo "$out" | grep -iE 'warn|error'; } || ok "hugo build clean"
rm -rf /tmp/blog-check-public
slug=$(basename "$f" .md); [ "$slug" = index ] && slug=$(basename "$(dirname "$f")")
url="https://he.ls1.dinnouti.com/blog/$type/$slug/"
code=$(curl -s -o /tmp/blog-check.html -w '%{http_code}' "$url")
[ "$code" = 200 ] && ok "preview $url -> 200" || bad "preview $url -> $code (run ./deploy-preview.sh first)"
if [ $type = recipes ]; then
  grep -q recipe-stat-key /tmp/blog-check.html && grep -q recipe-ingredient /tmp/blog-check.html && ok "recipe markup present" || bad "recipe markup missing"
fi
rm -f /tmp/blog-check.html
[ $fail = 0 ] && echo "ALL CHECKS PASSED" || echo "CHECKS FAILED"
exit $fail
