import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()); // coverage:ignore-line

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

// coverage:ignore-start
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'sheipe.db'));
    return NativeDatabase.createInBackground(file);
  });
}
// coverage:ignore-end
