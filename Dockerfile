ARG BASE_IMAGE=ghcr.io/actions/actions-runner
ARG RUNNER_VERSION=latest

FROM ${BASE_IMAGE}:${RUNNER_VERSION}
ARG DOCKER_COMPOSE_VERSION=latest

USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libmysqlclient-dev \
    libyaml-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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
