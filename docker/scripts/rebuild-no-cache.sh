#!/bin/bash

echo "🛑 Stopping containers..."
docker-compose --env-file .env.docker -f docker/docker-compose.yml down -v

echo ""
echo "🏗️  Rebuilding image WITHOUT CACHE..."
docker-compose --env-file .env.docker -f docker/docker-compose.yml build --no-cache

echo ""
echo "🚀 Starting containers..."
docker-compose --env-file .env.docker -f docker/docker-compose.yml up -d

echo ""
echo "⏳ Waiting 10 seconds..."
sleep 10

echo ""
echo "✅ Checking config..."
sh ./docker/scripts/check-config.sh
