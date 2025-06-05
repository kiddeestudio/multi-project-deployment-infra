#!/bin/bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <project-name>" >&2
  exit 1
fi

PROJECT_NAME="$1"
DEST_DIR="./projects/$PROJECT_NAME"

if [ -d "$DEST_DIR" ]; then
  echo "Project '$PROJECT_NAME' already exists at $DEST_DIR" >&2
  exit 1
fi

mkdir -p ./projects
cp -r ./_project-template "$DEST_DIR"

cp "$DEST_DIR/.env.example" "$DEST_DIR/.env"
sed -i "s/^PROJECT_NAME=.*/PROJECT_NAME=$PROJECT_NAME/" "$DEST_DIR/.env"

echo "Created project at $DEST_DIR"
