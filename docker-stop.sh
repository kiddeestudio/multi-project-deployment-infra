#!/bin/bash

# Parse --only=<project>
ONLY_PROJECT=""
for arg in "$@"; do
  if [[ "$arg" == --only=* ]]; then
    ONLY_PROJECT="${arg#--only=}"
  fi
done

echo "🛑 Stopping projects..."
for dir in ./projects/*/; do
  BASENAME=$(basename "$dir")
  if [[ -n "$ONLY_PROJECT" && "$BASENAME" != "$ONLY_PROJECT" ]]; then
    continue
  fi

  echo "⛔ Stopping: $BASENAME"
  cd "$dir" && docker compose down
  cd - > /dev/null
done

# Stop reverse proxy only if no --only flag was set
if [[ -z "$ONLY_PROJECT" ]]; then
  echo "🛑 Stopping reverse proxy..."
  cd ./reverse-proxy && docker compose down
  cd - > /dev/null
fi

echo "✅ Done."
