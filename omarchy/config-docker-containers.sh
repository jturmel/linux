#!/usr/bin/env bash

set -e

# Container definitions: name|image|run_args
# Easy to add new containers - just add a new line to this array
CONTAINERS=(
  "blackd|ceeveeya/blackd:latest|-p 45484:45484 --restart unless-stopped"
  "kroki|yuzutech/kroki:latest|-p 7105:8000 --restart unless-stopped"
  "crawl4ai|unclecode/crawl4ai:latest|-p 11235:11235 --restart unless-stopped --shm-size=1g"
  "lightpanda|lightpanda/browser:latest|-p 9222:9222 --restart unless-stopped"
)

# Compute a hash of the configuration to detect changes
config_hash() {
  local image="$1"
  local run_args="$2"
  echo -n "${image}:${run_args}" | sha256sum | cut -d' ' -f1 | cut -c1-12
}

# Check if Docker is available
require_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is not installed or not in PATH" >&2
    exit 1
  fi
}

# Check if container exists
container_exists() {
  local name="$1"
  docker ps -a --format '{{.Names}}' | grep -q "^${name}$"
}

# Get container's current image ID
get_container_image_id() {
  local name="$1"
  docker inspect --format='{{.Image}}' "$name" 2>/dev/null || echo ""
}

# Get container's stored config hash
get_container_config_hash() {
  local name="$1"
  docker inspect --format='{{.Config.Labels.jt_config_hash}}' "$name" 2>/dev/null || echo ""
}

# Check if container is running
container_is_running() {
  local name="$1"
  docker ps --format '{{.Names}}' | grep -q "^${name}$"
}

# Pull the latest image and return its ID
pull_and_get_image_id() {
  local image="$1"
  echo "Pulling latest image for $image..." >&2
  docker pull "$image" >&2
  docker inspect --format='{{.Id}}' "$image" 2>/dev/null
}

# Ensure a container exists and is up to date
ensure_container() {
  local name="$1"
  local image="$2"
  local run_args="$3"
  
  local desired_hash
  desired_hash=$(config_hash "$image" "$run_args")
  
  echo "Checking container: $name"
  
  if container_exists "$name"; then
    local current_image_id
    local stored_hash
    local latest_image_id
    
    current_image_id=$(get_container_image_id "$name")
    stored_hash=$(get_container_config_hash "$name")
    latest_image_id=$(pull_and_get_image_id "$image")
    
    # Check if we need to recreate
    if [ "$current_image_id" != "$latest_image_id" ]; then
      echo "  Image changed, recreating $name..."
      docker rm -f "$name" >/dev/null 2>&1
    elif [ "$stored_hash" != "$desired_hash" ]; then
      echo "  Config changed, recreating $name..."
      docker rm -f "$name" >/dev/null 2>&1
    elif container_is_running "$name"; then
      echo "  $name is up to date and running"
      return 0
    else
      echo "  $name is up to date, starting..."
      docker start "$name" >/dev/null
      echo "  $name started"
      return 0
    fi
  else
    # Container doesn't exist, pull the image
    pull_and_get_image_id "$image" >/dev/null
  fi
  
  # Create the container
  echo "  Creating $name..."
  # shellcheck disable=SC2086
  docker run -d \
    --name "$name" \
    --label "jt_config_hash=$desired_hash" \
    $run_args \
    "$image" >/dev/null
  
  echo "  $name created and started"
}

# Main
main() {
  require_docker
  
  echo "Ensuring Docker containers are up to date..."
  echo ""
  
  for container_def in "${CONTAINERS[@]}"; do
    # Parse the definition (format: name|image|run_args)
    IFS='|' read -r name image run_args <<< "$container_def"
    ensure_container "$name" "$image" "$run_args"
  done
  
  echo ""
  echo "All containers up to date."
}

main "$@"
