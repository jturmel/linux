#!/usr/bin/env bash
# Register Docker containers configuration

# Register post-config hook for Docker containers
register_post_config_hook '
    # Container definitions: name|image|run_args
    local containers=(
        "blackd|ceeveeya/blackd:latest|-p 45484:45484 --restart unless-stopped"
        "kroki|yuzutech/kroki:latest|-p 7105:8000 --restart unless-stopped"
        "crawl4ai|unclecode/crawl4ai:latest|-p 11235:11235 --restart unless-stopped --shm-size=1g"
        "lightpanda|lightpanda/browser:latest|-p 9222:9222 --restart unless-stopped"
    )

    # Check if Docker is available
    if ! command -v docker &>/dev/null; then
        log_warn "Docker not available, skipping container setup"
        record_skipped "docker containers (docker not installed)"
        return 0
    fi

    # Check if user can use Docker without sudo
    if ! docker ps &>/dev/null; then
        log_warn "Docker requires sudo or user not in docker group"
        record_manual_followup "Add user to docker group: sudo usermod -aG docker $USER (then logout/login)"
        record_skipped "docker containers (permission issue)"
        return 0
    fi

    log_info "Ensuring Docker containers are up to date..."

    local container_def
    for container_def in "${containers[@]}"; do
        # Parse the definition (format: name|image|run_args)
        IFS="|" read -r name image run_args <<< "$container_def"

        log_info "Checking container: $name"

        # Check if container exists
        if docker ps -a --format "{{.Names}}" | grep -q "^${name}$"; then
            local current_image_id
            local latest_image_id

            current_image_id=$(docker inspect --format="{{.Image}}" "$name" 2>/dev/null || echo "")

            log_info "  Pulling latest image for $image..."
            docker pull "$image" &>/dev/null
            latest_image_id=$(docker inspect --format="{{.Id}}" "$image" 2>/dev/null || echo "")

            # Check if we need to recreate
            if [[ "$current_image_id" != "$latest_image_id" ]]; then
                log_info "  Image changed, recreating $name..."
                docker rm -f "$name" &>/dev/null
            elif docker ps --format "{{.Names}}" | grep -q "^${name}$"; then
                log_info "  $name is up to date and running"
                record_completed "container: $name"
                continue
            else
                log_info "  $name is up to date, starting..."
                docker start "$name" &>/dev/null
                log_info "  $name started"
                record_completed "container: $name"
                continue
            fi
        else
            # Container does not exist, pull the image
            log_info "  Pulling image for $image..."
            docker pull "$image" &>/dev/null
        fi

        # Create the container
        log_info "  Creating $name..."
        # shellcheck disable=SC2086
        if docker run -d --name "$name" $run_args "$image" &>/dev/null; then
            log_info "  $name created and started"
            record_completed "container: $name"
        else
            log_error "  Failed to create $name"
            record_failed "container: $name"
        fi
    done

    log_info "Docker containers setup complete."
'
