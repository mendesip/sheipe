FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    libpq-dev \
    curl \
    git \
    unzip \
    xz-utils \
    ca-certificates \
    postgresql-client \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

# Ruby via rbenv + ruby-build
ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:${PATH}"

RUN git clone --depth 1 https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && git clone --depth 1 https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build" \
  && rbenv install 3.3.10 \
  && rbenv global 3.3.10 \
  && rbenv rehash \
  && gem update --system --no-document \
  && gem install bundler ruby-lsp --no-document \
  && rbenv rehash

# Starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes \
  && echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc

# RTK (token optimizer) and Caveman (AI agent toolkit)
ENV PATH="/root/.local/bin:${PATH}"
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh \
  && curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

WORKDIR /workspace
