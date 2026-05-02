#!/usr/bin/env bash
set -euo pipefail

echo "==> [1/5] Installing Claude Code Superpowers plugin..."
claude plugins install superpowers@claude-plugins-official --scope user

echo "==> [2/5] Installing Ruby gems..."
cd /workspace/apps/sheipe_api
bundle install

echo "==> [3/5] Setting up database..."
bundle exec rails db:create db:migrate

echo "==> [4/5] Installing Flutter dependencies and generating code..."
cd /workspace/apps/sheipe_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs

echo "==> [5/5] Verifying Flutter setup..."
flutter analyze || true

echo ""
echo "Dev container ready."
echo "  API:    cd apps/sheipe_api && rails server"
echo "  Tests:  cd apps/sheipe_app && flutter test"
