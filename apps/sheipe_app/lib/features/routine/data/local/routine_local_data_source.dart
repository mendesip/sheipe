import 'package:drift/drift.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/routine.dart';
import '../../domain/entities/routine_exercise.dart';
import '../../domain/entities/routine_set.dart';

class RoutineLocalDataSource {
  RoutineLocalDataSource({required this.db});

  final AppDatabase db;

  Stream<List<Routine>> watchAll({String? creatorId}) {
    final select = db.select(db.routinesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (creatorId != null) {
      select.where((t) => t.creatorId.equals(creatorId));
    }
    return select.watch().asyncMap((rows) async {
      final result = <Routine>[];
      for (final r in rows) {
        result.add(await _hydrate(r));
      }
      return result;
    });
  }

  Stream<Routine?> watchById(String id) {
    return (db.select(db.routinesTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((r) async => r == null ? null : await _hydrate(r));
  }

  Future<Routine?> findById(String id) async {
    final row = await (db.select(db.routinesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _hydrate(row);
  }

  Future<void> upsert(Routine routine) async {
    await db.transaction(() async {
      await db.into(db.routinesTable).insertOnConflictUpdate(
            RoutinesTableCompanion.insert(
              id: routine.id,
              name: routine.name,
              description: Value(routine.description),
              creatorId: routine.creatorId,
              isTemplate: Value(routine.isTemplate),
              createdAt: Value(routine.createdAt),
              updatedAt: Value(routine.updatedAt),
            ),
          );
      // Replace nested exercises and sets
      await (db.delete(db.routineExercisesTable)..where((t) => t.routineId.equals(routine.id))).go();
      for (final re in routine.exercises) {
        await db.into(db.routineExercisesTable).insertOnConflictUpdate(
              RoutineExercisesTableCompanion.insert(
                id: re.id,
                routineId: routine.id,
                exerciseId: re.exerciseId,
                position: re.position,
                notes: Value(re.notes),
              ),
            );
        for (final s in re.sets) {
          await db.into(db.routineSetsTable).insertOnConflictUpdate(
                RoutineSetsTableCompanion.insert(
                  id: s.id,
                  routineExerciseId: re.id,
                  setNumber: s.setNumber,
                  weight: Value(s.weight),
                  reps: Value(s.reps),
                  restSeconds: Value(s.restSeconds),
                  setType: Value(s.setType),
                ),
              );
        }
      }
    });
  }

  Future<void> upsertAll(List<Routine> routines) async {
    for (final r in routines) {
      await upsert(r);
    }
  }

  Future<void> deleteById(String id) async {
    await (db.delete(db.routinesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<Routine> _hydrate(RoutinesTableData row) async {
    final exercises = await (db.select(db.routineExercisesTable)
          ..where((t) => t.routineId.equals(row.id))
          ..orderBy([(t) => OrderingTerm(expression: t.position)]))
        .get();
    final hydrated = <RoutineExercise>[];
    for (final re in exercises) {
      final sets = await (db.select(db.routineSetsTable)
            ..where((t) => t.routineExerciseId.equals(re.id))
            ..orderBy([(t) => OrderingTerm(expression: t.setNumber)]))
          .get();
      hydrated.add(RoutineExercise(
        id: re.id,
        routineId: re.routineId,
        exerciseId: re.exerciseId,
        position: re.position,
        notes: re.notes,
        sets: sets
            .map((s) => RoutineSet(
                  id: s.id,
                  routineExerciseId: s.routineExerciseId,
                  setNumber: s.setNumber,
                  setType: s.setType,
                  weight: s.weight,
                  reps: s.reps,
                  restSeconds: s.restSeconds,
                ))
            .toList(),
      ));
    }
    return Routine(
      id: row.id,
      name: row.name,
      creatorId: row.creatorId,
      description: row.description,
      isTemplate: row.isTemplate,
      exercises: hydrated,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
