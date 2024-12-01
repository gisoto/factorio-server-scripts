#!/bin/bash

script_dir=$(dirname -- "$(readlink --canonicalize -- "${BASH_SOURCE[0]}")")

container_name="factorio"
# check for custom container name
if [ -n "$1" ]; then
  container_name="$1"
fi

mkdir --parents "$script_dir"/logs
# redirect stdout/stderr to log file
exec >>"$script_dir"/logs/update-factorio."$(date --iso-8601)".log 2>&1

# execution timestamp
printf "\n\n=========================\n"
date --iso-8601=seconds

#pull latest docker image
echo "Pulling the latest image version."
docker compose --file "$script_dir"/docker-compose.yml pull --quiet
new_image_id=$(docker inspect --format "{{.Id}}" factoriotools/factorio:stable)

# check if container does not exists
if ! docker inspect "$container_name" > /dev/null 2>&1; then
  echo "Container $container_name does not exist."
  docker compose --file "$script_dir"/docker-compose.yml up --detach
  exit 0
fi
echo "Container $container_name exists."

# check if the container is not running
if ! docker inspect --format '{{.State.Status}}' "$container_name" | grep --quiet "running"; then
  echo "Container $container_name is not running."
  echo "Recreating container $container_name with the latest image version."
  docker compose --file "$script_dir"/docker-compose.yml down
  docker compose --file "$script_dir"/docker-compose.yml up --detach
  exit 0
fi
echo "Container $container_name is running."
container_image_id=$(docker inspect --format "{{.Image}}" "$container_name")

echo "Checking player count on the server before updating."
players_online=$(docker exec factorio rcon /players o)
player_count=$(($(echo "$players_online" | wc --lines) - 1))

echo "$players_online"
if [ $player_count -gt 0 ]; then
  echo "Server is not empty, skipping update."
  exit 0
fi

if [ "$new_image_id" = "$container_image_id" ]; then
  echo "Container $container_name is already running the latest image version."
  exit 0
fi
echo "Recreating container $container_name with the latest image version."
docker compose --file "$script_dir"/docker-compose.yml down;
docker compose --file "$script_dir"/docker-compose.yml up --detach;
factorio_version=$(docker inspect --format '{{index .Config.Labels "factorio.version"}}' "$container_name")
echo "Factorio version: $factorio_version"
