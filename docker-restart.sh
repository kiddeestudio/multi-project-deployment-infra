#!/bin/bash

echo "🔄 รีสตาร์ททุกบริการ..."
./docker-stop.sh "$@"
./docker-start.sh "$@"
