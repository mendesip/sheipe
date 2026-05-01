import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheipe_app/core/storage/app_database.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('AppDatabase opens without error', () async {
    expect(db, isA<AppDatabase>());
  });

  test('schemaVersion is 1', () {
    expect(db.schemaVersion, 1);
  });

  test('SC-005: constructor takes only executor; table list is in annotation', () {
    final db2 = AppDatabase.forTesting(NativeDatabase.memory());
    expect(db2, isA<AppDatabase>());
    db2.close();
  });
}
