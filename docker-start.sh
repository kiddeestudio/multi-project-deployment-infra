#!/bin/bash

# Parse --only=<project>
ONLY_PROJECT=""
for arg in "$@"; do
  if [[ "$arg" == --only=* ]]; then
    ONLY_PROJECT="${arg#--only=}"
  fi
done

# สร้าง network ถ้ายังไม่มี
if ! docker network ls | grep "proxy"; then
  echo "🔧 Creating Docker network 'proxy'..."
  docker network create proxy
else
  echo "✅ Docker network 'proxy' already exists."
fi

# Start reverse proxy
echo "🚀 Starting reverse proxy..."
cd ./reverse-proxy && docker compose up -d
cd - > /dev/null

# Start projects
echo "🚀 Starting projects..."
for dir in ./projects/*/; do
  BASENAME=$(basename "$dir")
  if [[ -n "$ONLY_PROJECT" && "$BASENAME" != "$ONLY_PROJECT" ]]; then
    continue
  fi

  echo "▶ Starting: $BASENAME"
  cd "$dir" && docker compose up -d
  cd - > /dev/null
done

echo "✅ All services started."
