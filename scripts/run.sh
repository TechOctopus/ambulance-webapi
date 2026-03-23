#!/bin/bash

COMMAND=${1:-"start"}

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="neUhaDnes"

mongo_cmd() {
    docker compose --file "${PROJECT_ROOT}/deployments/docker-compose/compose.yaml" "$@"
}

case "$COMMAND" in
    "openapi")
        docker run --rm -it -v "${PROJECT_ROOT}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;

    "start")
        trap 'mongo_cmd down' EXIT
        
        echo "Starting MongoDB..."
        mongo_cmd up --detach
        
        echo "Starting API Service..."
        go run "${PROJECT_ROOT}/cmd/ambulance-api-service"
        ;;

    "test")
        go test -v ./...
        ;;

    "mongo")
        mongo_cmd up
        ;;

    *)
        echo "Unknown command: $COMMAND"
        exit 1
        ;;
esac