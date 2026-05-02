import 'package:uuid/uuid.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_set.dart';
import '../local/workout_local_data_source.dart';
import '../remote/workout_remote_data_source.dart';

/// Offline-first workout repository.
///
/// Most writes follow the standard "Drift first, enqueue sync" pattern.
/// One exception: [logActiveSet] also fires a fire-and-forget API call
/// so an active session is real-time persisted even if the queue is
/// momentarily backed up.
class WorkoutRepository {
  WorkoutRepository({
    required this.local,
    required this.remote,
    required this.queue,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final WorkoutLocalDataSource local;
  final WorkoutRemoteDataSource remote;
  final SyncQueue queue;
  final Uuid _uuid;

  Stream<List<Workout>> watchAll({String? userId}) => local.watchAll(userId: userId);

  Stream<Workout?> watchById(String id) => local.watchById(id);

  Future<Workout?> findById(String id) => local.findById(id);

  Future<Workout> startFreeWorkout({required String userId}) async {
    final w = Workout(
      id: _uuid.v4(),
      userId: userId,
      startedAt: DateTime.now(),
    );
    await local.upsert(w);
    await queue.enqueue(
      entityType: 'workout',
      entityId: w.id,
      operation: SyncOp.create,
      payload: w.toJson(),
    );
    return w;
  }

  Future<Workout> startFromRoutine({required String userId, required String routineId}) async {
    // Server-side pre-population is the source of truth; for the offline path
    // we just create the empty workout and let the sync push send routine_id.
    final w = Workout(
      id: _uuid.v4(),
      userId: userId,
      routineId: routineId,
      startedAt: DateTime.now(),
    );
    await local.upsert(w);
    await queue.enqueue(
      entityType: 'workout',
      entityId: w.id,
      operation: SyncOp.create,
      payload: w.toJson(),
    );
    return w;
  }

  Future<WorkoutExercise> addExercise({
    required String workoutId,
    required String exerciseId,
    required int position,
  }) async {
    final we = WorkoutExercise(
      id: _uuid.v4(),
      workoutId: workoutId,
      exerciseId: exerciseId,
      position: position,
    );
    final workout = await local.findById(workoutId);
    if (workout != null) {
      await local.upsert(workout.copyWith(exercises: [...workout.exercises, we]));
    }
    await queue.enqueue(
      entityType: 'workout_exercise',
      entityId: we.id,
      operation: SyncOp.create,
      payload: {'workout_id': workoutId, ...we.toJson()},
    );
    return we;
  }

  /// Logs a set during an active workout. Writes to Drift, then fires the
  /// remote API call without awaiting it (best-effort persistence).
  Future<WorkoutSet> logActiveSet({
    required String workoutId,
    required WorkoutSet set,
  }) async {
    final stamped = set.id.isEmpty ? set.copyWith(id: _uuid.v4()) : set;
    await local.upsertSet(stamped);
    // Fire-and-forget; failures are silently swallowed for now.
    // The sync queue will reconcile if this fails.
    Future<void>(() async {
      try {
        await remote.logSet(
          workoutId: workoutId,
          weId: stamped.workoutExerciseId,
          set: stamped,
        );
      } catch (_) {
        await queue.enqueue(
          entityType: 'workout_set',
          entityId: stamped.id,
          operation: SyncOp.create,
          payload: {'workout_id': workoutId, ...stamped.toJson()},
        );
      }
    });
    return stamped;
  }

  Future<WorkoutSet> updateActiveSet({
    required String workoutId,
    required WorkoutSet set,
  }) async {
    await local.upsertSet(set);
    Future<void>(() async {
      try {
        await remote.updateSet(
          workoutId: workoutId,
          weId: set.workoutExerciseId,
          set: set,
        );
      } catch (_) {
        await queue.enqueue(
          entityType: 'workout_set',
          entityId: set.id,
          operation: SyncOp.update,
          payload: {'workout_id': workoutId, ...set.toJson()},
        );
      }
    });
    return set;
  }

  Future<void> deleteSet({
    required String workoutId,
    required String weId,
    required String setId,
  }) async {
    await local.deleteSet(setId);
    await queue.enqueue(
      entityType: 'workout_set',
      entityId: setId,
      operation: SyncOp.delete,
      payload: {'workout_id': workoutId, 'workout_exercise_id': weId},
    );
  }

  Future<Workout> finish(String workoutId) async {
    final current = await local.findById(workoutId);
    if (current == null) {
      throw StateError('Cannot finish unknown workout $workoutId');
    }
    if (current.finishedAt != null) return current;
    final finished = current.copyWith(finishedAt: DateTime.now());
    await local.upsert(finished);
    await queue.enqueue(
      entityType: 'workout',
      entityId: workoutId,
      operation: SyncOp.finish,
    );
    return finished;
  }

  Future<Workout> updateWorkout(Workout workout) async {
    final stamped = workout.copyWith(updatedAt: DateTime.now());
    await local.upsert(stamped);
    await queue.enqueue(
      entityType: 'workout',
      entityId: stamped.id,
      operation: SyncOp.update,
      payload: stamped.toJson(),
    );
    return stamped;
  }

  Future<void> delete(String id) async {
    await local.deleteById(id);
    await queue.enqueue(
      entityType: 'workout',
      entityId: id,
      operation: SyncOp.delete,
    );
  }

  Future<void> refreshFromRemote() async {
    final remoteList = await remote.getAll();
    await local.upsertAll(remoteList);
  }

  Future<void> refreshOne(String id) async {
    final fresh = await remote.getById(id);
    await local.upsert(fresh);
  }
}
