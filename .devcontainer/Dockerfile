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
    libglib2.0-0 \
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
  && gem install bundler --no-document

# Flutter SDK (libglib2.0-0 required by Dart VM on Ubuntu)
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}"
ENV FLUTTER_NO_ANALYTICS=true
ENV PUB_NO_SELF_UPDATE=true

RUN git clone --depth 1 \
      --branch 3.41.6 \
      https://github.com/flutter/flutter.git \
      "${FLUTTER_ROOT}" \
  && flutter precache --no-android --no-ios --no-fuchsia --no-macos --no-windows \
  && flutter doctor --suppress-analytics

WORKDIR /workspace
