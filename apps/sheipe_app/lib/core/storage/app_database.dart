import 'package:drift/drift.dart';
import 'connection/native.dart'
    if (dart.library.js_interop) 'connection/web.dart';

part 'app_database.g.dart';

class ExercisesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get muscleGroup => text()();
  TextColumn get category => text()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  TextColumn get creatorId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutinesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get creatorId => text()();
  BoolColumn get isTemplate => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutineExercisesTable extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text().references(RoutinesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  IntColumn get position => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RoutineSetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get routineExerciseId =>
      text().references(RoutineExercisesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get setNumber => integer()();
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get setType => text().withDefault(const Constant('working'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get routineId => text().nullable()();
  TextColumn get gymId => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get trainerNotes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutExercisesTable extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId => text().references(WorkoutsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  TextColumn get routineExerciseId => text().nullable()();
  IntColumn get position => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get workoutExerciseId =>
      text().references(WorkoutExercisesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get setNumber => integer()();
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();
  RealColumn get rpe => real().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncOperationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // create | update | delete
  TextColumn get payload => text().nullable()(); // JSON-encoded body
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  ExercisesTable,
  RoutinesTable,
  RoutineExercisesTable,
  RoutineSetsTable,
  WorkoutsTable,
  WorkoutExercisesTable,
  WorkoutSetsTable,
  SyncOperationsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()); // coverage:ignore-line

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createAll();
          }
        },
      );
}

// coverage:ignore-start
DatabaseConnection _openConnection() => connect();
// coverage:ignore-end
