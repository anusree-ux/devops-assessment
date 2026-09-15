#!/bin/bash

set -e

COMPOSE="docker compose --env-file .env"

case "$1" in
    start)
        echo "Starting local development application..."
        $COMPOSE up --build -d
        ;;

    stop)
        echo "Stopping application..."
        $COMPOSE down
        ;;

    restart)
        echo "Restarting application..."
        $COMPOSE down
        $COMPOSE up --build -d
        ;;

    status)
        echo "Application Status:"
        $COMPOSE ps
        ;;

    logs)
        echo "Showing application logs..."
        $COMPOSE logs -f
        ;;

    *)
        echo "Usage: ./scripts/local.sh {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
