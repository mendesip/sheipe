#!/usr/bin/env bash
set -euo pipefail

echo "==> [1/2] Installing Ruby gems..."
cd /workspace
bundle install

echo "==> [2/2] Setting up database..."
bundle exec rails db:create db:migrate

echo ""
echo "Dev container ready."
echo "  API: rails server"
