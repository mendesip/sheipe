# Data Model: Monorepo Foundation Scaffold

No database entities are introduced in this phase.

The only database artifact is the PostgreSQL extension migration that enables
UUID generation for all future models:

```ruby
# db/migrate/TIMESTAMP_enable_pgcrypto.rb
enable_extension 'pgcrypto'
```

All future `create_table` calls will use:
```ruby
create_table :table_name, id: :uuid, default: "gen_random_uuid()" do |t|
  # ...
end
```

The Drift `AppDatabase` on the Flutter side is initialised with zero tables
(`@DriftDatabase(tables: [])`), schema version 1. Future features add their
own Drift table classes and increment the schema version.
