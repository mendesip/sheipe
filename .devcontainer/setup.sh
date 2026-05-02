#!/usr/bin/env bash
set -euo pipefail

echo "==> [1/4] Installing Ruby gems..."
cd /workspace/apps/sheipe_api
bundle install

echo "==> [2/4] Setting up database..."
bundle exec rails db:create db:migrate

echo "==> [3/4] Installing Flutter dependencies and generating code..."
cd /workspace/apps/sheipe_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs

echo "==> [4/4] Verifying Flutter setup..."
flutter analyze || true

echo ""
echo "Dev container ready."
echo "  API:    cd apps/sheipe_api && rails server"
echo "  Tests:  cd apps/sheipe_app && flutter test"
