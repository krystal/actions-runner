#!/bin/bash
set -euo pipefail

# Get action-runner version.
RUNNER_VERSION=$(
  /home/runner/bin/Runner.Listener --version 2>/dev/null |
    grep -E 'Version: .+' |
    sed -E 's/.*Version: ([0-9.]+).*/\1/' ||
    echo "unknown"
)

# Installed tools.
DOCKER_CLI_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//' | sed 's/^v//')
DOCKER_COMPOSE_VERSION=$(docker compose version --short | sed 's/^v//')
GH_VERSION=$(gh --version | head -1 | awk '{print $3}' | sed 's/^v//')
UBI_VERSION=$(ubi --version 2>&1 | head -1 | awk '{print $2}' | sed 's/^v//')
YQ_VERSION=$(yq --version | awk '{print $NF}' | sed 's/^v//')

# Installed packages.
PACKAGES=(
  build-essential
  curl
  git
  jc
  jq
  liblzma-dev
  libmysqlclient-dev
  libssl-dev
  libxml2-dev
  libyaml-dev
  openssh-client
  patch
  wget
  zlib1g-dev
)

# Output versions in JSON format via yq as YAML is easier to print here.
{
  echo "actions_runner: \"${RUNNER_VERSION}\""
  echo "tools:"
  echo "  docker-cli: \"${DOCKER_CLI_VERSION}\""
  echo "  docker-compose: \"${DOCKER_COMPOSE_VERSION}\""
  echo "  gh: \"${GH_VERSION}\""
  echo "  ubi: \"${UBI_VERSION}\""
  echo "  yq: \"${YQ_VERSION}\""

  echo "packages:"
  for pkg in "${PACKAGES[@]}"; do
    PKG_VERSION=$(dpkg -s "$pkg" | grep Version | cut -d' ' -f2)
    echo "  ${pkg}: \"${PKG_VERSION}\""
  done
} | yq -o=json
