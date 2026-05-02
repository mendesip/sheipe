import 'package:drift/drift.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_set.dart';

class WorkoutLocalDataSource {
  WorkoutLocalDataSource({required this.db});

  final AppDatabase db;

  Stream<List<Workout>> watchAll({String? userId}) {
    final select = db.select(db.workoutsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    if (userId != null) {
      select.where((t) => t.userId.equals(userId));
    }
    return select.watch().asyncMap((rows) async {
      final result = <Workout>[];
      for (final r in rows) {
        result.add(await _hydrate(r));
      }
      return result;
    });
  }

  Stream<Workout?> watchById(String id) {
    return (db.select(db.workoutsTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((r) async => r == null ? null : await _hydrate(r));
  }

  Future<Workout?> findById(String id) async {
    final row = await (db.select(db.workoutsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _hydrate(row);
  }

  Future<void> upsert(Workout workout) async {
    await db.transaction(() async {
      await db.into(db.workoutsTable).insertOnConflictUpdate(
            WorkoutsTableCompanion.insert(
              id: workout.id,
              userId: workout.userId,
              routineId: Value(workout.routineId),
              gymId: Value(workout.gymId),
              startedAt: workout.startedAt,
              finishedAt: Value(workout.finishedAt),
              notes: Value(workout.notes),
              trainerNotes: Value(workout.trainerNotes),
              createdAt: Value(workout.createdAt),
              updatedAt: Value(workout.updatedAt),
            ),
          );
      await (db.delete(db.workoutExercisesTable)..where((t) => t.workoutId.equals(workout.id))).go();
      for (final we in workout.exercises) {
        await db.into(db.workoutExercisesTable).insertOnConflictUpdate(
              WorkoutExercisesTableCompanion.insert(
                id: we.id,
                workoutId: workout.id,
                exerciseId: we.exerciseId,
                routineExerciseId: Value(we.routineExerciseId),
                position: we.position,
                notes: Value(we.notes),
              ),
            );
        for (final s in we.sets) {
          await upsertSet(s);
        }
      }
    });
  }

  Future<void> upsertAll(List<Workout> workouts) async {
    for (final w in workouts) {
      await upsert(w);
    }
  }

  Future<void> upsertSet(WorkoutSet s) async {
    await db.into(db.workoutSetsTable).insertOnConflictUpdate(
          WorkoutSetsTableCompanion.insert(
            id: s.id,
            workoutExerciseId: s.workoutExerciseId,
            setNumber: s.setNumber,
            weight: Value(s.weight),
            reps: Value(s.reps),
            rpe: Value(s.rpe),
            completed: Value(s.completed),
            notes: Value(s.notes),
          ),
        );
  }

  Future<void> deleteById(String id) async {
    await (db.delete(db.workoutsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteSet(String setId) async {
    await (db.delete(db.workoutSetsTable)..where((t) => t.id.equals(setId))).go();
  }

  Future<Workout> _hydrate(WorkoutsTableData row) async {
    final exercises = await (db.select(db.workoutExercisesTable)
          ..where((t) => t.workoutId.equals(row.id))
          ..orderBy([(t) => OrderingTerm(expression: t.position)]))
        .get();
    final hydrated = <WorkoutExercise>[];
    for (final we in exercises) {
      final sets = await (db.select(db.workoutSetsTable)
            ..where((t) => t.workoutExerciseId.equals(we.id))
            ..orderBy([(t) => OrderingTerm(expression: t.setNumber)]))
          .get();
      hydrated.add(WorkoutExercise(
        id: we.id,
        workoutId: we.workoutId,
        exerciseId: we.exerciseId,
        position: we.position,
        routineExerciseId: we.routineExerciseId,
        notes: we.notes,
        sets: sets
            .map((s) => WorkoutSet(
                  id: s.id,
                  workoutExerciseId: s.workoutExerciseId,
                  setNumber: s.setNumber,
                  weight: s.weight,
                  reps: s.reps,
                  rpe: s.rpe,
                  completed: s.completed,
                  notes: s.notes,
                ))
            .toList(),
      ));
    }
    return Workout(
      id: row.id,
      userId: row.userId,
      startedAt: row.startedAt,
      routineId: row.routineId,
      gymId: row.gymId,
      finishedAt: row.finishedAt,
      notes: row.notes,
      trainerNotes: row.trainerNotes,
      exercises: hydrated,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
