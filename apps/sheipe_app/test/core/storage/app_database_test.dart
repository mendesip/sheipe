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

  test('schemaVersion is 2', () {
    expect(db.schemaVersion, 2);
  });

  test('exposes all training tables', () async {
    expect(db.exercisesTable, isNotNull);
    expect(db.routinesTable, isNotNull);
    expect(db.routineExercisesTable, isNotNull);
    expect(db.routineSetsTable, isNotNull);
    expect(db.workoutsTable, isNotNull);
    expect(db.workoutExercisesTable, isNotNull);
    expect(db.workoutSetsTable, isNotNull);
    expect(db.syncOperationsTable, isNotNull);
  });

  test('can insert and read an exercise row', () async {
    await db.into(db.exercisesTable).insert(
          ExercisesTableCompanion.insert(
            id: 'ex-1',
            name: 'Bench Press',
            muscleGroup: 'chest',
            category: 'strength',
          ),
        );
    final row = await (db.select(db.exercisesTable)..where((t) => t.id.equals('ex-1'))).getSingle();
    expect(row.name, 'Bench Press');
    expect(row.isSystem, false);
  });

  test('SC-005: constructor takes only executor; table list is in annotation', () {
    final db2 = AppDatabase.forTesting(NativeDatabase.memory());
    expect(db2, isA<AppDatabase>());
    db2.close();
  });
}
