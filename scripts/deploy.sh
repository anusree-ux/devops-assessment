#!/bin/bash

set -e

COMPOSE="docker compose --env-file .env.prod -f docker-compose.prod.yml"

NEW_VERSION="$1"

if [ -z "$NEW_VERSION" ]; then
    echo "Usage: ./scripts/deploy.sh <commit-sha>"
    exit 1
fi

if [[ ! "$NEW_VERSION" =~ ^[0-9a-f]{40}$ ]]; then
    echo "Error: IMAGE_TAG must be a full 40-character commit SHA."
    exit 1
fi

echo "Deploying version:"
echo "$NEW_VERSION"

echo "Pulling published images from Docker Hub..."
IMAGE_TAG="$NEW_VERSION" $COMPOSE pull backend frontend

echo "Starting application..."
IMAGE_TAG="$NEW_VERSION" $COMPOSE up -d backend frontend

echo "Waiting for application to become healthy..."
sleep 10

echo "Verifying application..."

if curl --fail --silent http://app.debyez.localhost > /dev/null &&
   curl --fail --silent http://api.debyez.localhost/api/health > /dev/null &&
   curl --fail --silent http://api.debyez.localhost/api/health/db > /dev/null &&
   curl --fail --silent http://api.debyez.localhost/api/health/s3 > /dev/null; then

    echo "Health verification passed."

    echo "$NEW_VERSION" > deployment/current_version
    echo "$NEW_VERSION" > deployment/known_good_version

    echo "Deployment successful."
    echo "Current version: $NEW_VERSION"
    echo "Known-good version: $NEW_VERSION"

else

    echo "Health verification FAILED."
    echo "Starting automatic rollback..."

    ./scripts/rollback.sh

fi

