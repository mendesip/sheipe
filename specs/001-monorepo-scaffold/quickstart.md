# Quickstart: Monorepo Foundation

## Prerequisites

- Ruby ≥ 3.3 + Bundler
- PostgreSQL running locally
- Flutter SDK (stable channel) + Dart
- Xcode (iOS) or Android Studio (Android) for simulators

## sheipe_api

```bash
cd apps/sheipe_api
bundle install
rails db:create db:migrate
rails server
# → http://localhost:3000
```

**Verify**: `curl http://localhost:3000/` returns any response (not a boot crash).

**Run tests**: `bundle exec rspec`

## sheipe_app

```bash
cd apps/sheipe_app
flutter pub get
flutter run
```

**Verify auth guard**:
- With no token stored → app opens on auth placeholder screen
- With a token manually written to secure storage → app opens on main shell

**Run tests**: `flutter test --coverage`

## Validation

Both apps running:
1. Rails server responds at `localhost:3000`
2. Flutter app launches without errors on simulator
3. `GET http://localhost:3000/nonexistent` returns:
   ```json
   { "error": { "code": "not_found", "message": "...", "details": null } }
   ```
4. Test coverage ≥ 95% on both apps
