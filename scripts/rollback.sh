#!/bin/bash

set -e

COMPOSE="docker compose --env-file .env.prod -f docker-compose.prod.yml"

KNOWN_GOOD_VERSION=$(cat deployment/known_good_version)

echo "Rolling back to known-good version:"
echo "$KNOWN_GOOD_VERSION"

echo "Pulling previously published images..."
IMAGE_TAG="$KNOWN_GOOD_VERSION" $COMPOSE pull backend frontend

echo "Starting known-good version..."
IMAGE_TAG="$KNOWN_GOOD_VERSION" $COMPOSE up -d backend frontend

echo "Waiting for application to become healthy..."
sleep 10

echo "Verifying application..."

curl --fail --silent http://app.debyez.localhost > /dev/null
curl --fail --silent http://api.debyez.localhost/api/health > /dev/null
curl --fail --silent http://api.debyez.localhost/api/health/db > /dev/null
curl --fail --silent http://api.debyez.localhost/api/health/s3 > /dev/null

echo "$KNOWN_GOOD_VERSION" > deployment/current_version

echo "Rollback successful."
echo "Current version: $KNOWN_GOOD_VERSION"
