ARG BASE_IMAGE=ghcr.io/actions/actions-runner
ARG RUNNER_VERSION=latest

FROM ${BASE_IMAGE}:${RUNNER_VERSION}

USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    jc \
    jq \
    liblzma-dev \
    libmysqlclient-dev \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    openssh-client \
    patch \
    wget \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ubi — https://github.com/houseabsolute/ubi
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    curl -s https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh | sh \
    && ubi --version

# Install yq — https://github.com/mikefarah/yq
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    ubi --in /usr/local/bin --project mikefarah/yq \
    && yq --version

# Install gh (GitHub CLI) — https://github.com/cli/cli
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    ubi --in /usr/local/bin --project cli/cli --exe gh \
    && gh --version

# Install docker-compose — https://github.com/docker/compose
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    ubi --in /usr/local/lib/docker/cli-plugins/ --project docker/compose --exe docker-compose \
    && ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose \
    && docker compose version \
    && docker-compose version

ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
RUN mkdir -p "${RUNNER_TOOL_CACHE}" \
    && chgrp docker "${RUNNER_TOOL_CACHE}" \
    && chmod g+rwx "${RUNNER_TOOL_CACHE}"

USER runner
