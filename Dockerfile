ARG BASE_IMAGE=ghcr.io/actions/actions-runner
ARG RUNNER_VERSION=latest

FROM ${BASE_IMAGE}:${RUNNER_VERSION}

USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    jq \
    liblzma-dev \
    libmysqlclient-dev \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    patch \
    openssh-client \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG GH_VERSION=latest
RUN --mount=type=secret,id=github_token,dst=/run/secrets/github_token \
    ARCH="$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')" && \
    if [ "${GH_VERSION}" = "latest" ]; then \
    TOKEN="$(cat /run/secrets/github_token 2>/dev/null || true)" && \
    ([ -n "$TOKEN" ] && CURL_OPTS="-H \"Authorization: token $TOKEN\"" || CURL_OPTS="") && \
    curl $CURL_OPTS -s "https://api.github.com/repos/cli/cli/releases/latest" | \
    jq -r --arg arch "$ARCH" '.assets[] | select(.name | endswith("_linux_" + $arch + ".deb")) | .browser_download_url' | \
    xargs curl -L -o /tmp/gh-cli.deb; \
    else \
    curl -L "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_$ARCH.deb" -o /tmp/gh-cli.deb; \
    fi; \
    dpkg -i /tmp/gh-cli.deb && rm /tmp/gh-cli.deb

ARG DOCKER_COMPOSE_VERSION=latest
RUN [ "${DOCKER_COMPOSE_VERSION}" = "latest" ] \
    && curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose \
    || curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose \
    && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose \
    && ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose \
    && docker compose version \
    && docker-compose version

ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
RUN mkdir -p "${RUNNER_TOOL_CACHE}" \
    && chgrp docker "${RUNNER_TOOL_CACHE}" \
    && chmod g+rwx "${RUNNER_TOOL_CACHE}"

USER runner
