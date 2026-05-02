import 'dart:async';
import 'dart:convert';
import '../storage/app_database.dart';
import 'sync_queue.dart';
import '../../features/exercise/data/remote/exercise_remote_data_source.dart';
import '../../features/exercise/domain/entities/exercise.dart';
import '../../features/routine/data/remote/routine_remote_data_source.dart';
import '../../features/routine/domain/entities/routine.dart';
import '../../features/workout/data/remote/workout_remote_data_source.dart';
import '../../features/workout/domain/entities/workout_set.dart';

/// Drains the [SyncQueue] by dispatching pending operations to the
/// appropriate remote data source. On success the op is marked synced;
/// on failure attempt_count is incremented and last_error is stored.
class SyncService {
  SyncService({
    required this.queue,
    required this.exerciseRemote,
    required this.routineRemote,
    required this.workoutRemote,
  });

  final SyncQueue queue;
  final ExerciseRemoteDataSource exerciseRemote;
  final RoutineRemoteDataSource routineRemote;
  final WorkoutRemoteDataSource workoutRemote;

  bool _running = false;
  Timer? _tickTimer;

  /// Starts a periodic queue drain loop. Called by `main.dart` when auth
  /// transitions to `AuthAuthenticated`. Calling it more than once is a
  /// no-op so widget rebuilds don't multiply timers.
  void start({Duration interval = const Duration(seconds: 30)}) {
    if (_tickTimer != null) return;
    _tickTimer = Timer.periodic(interval, (_) => processQueue());
    // Immediate kick so anything queued before app start gets pushed.
    unawaited(processQueue());
  }

  void stop() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  Future<void> processQueue() async {
    if (_running) return;
    _running = true;
    try {
      final pending = await queue.pending();
      for (final op in pending) {
        try {
          await _dispatch(op);
          await queue.markSynced(op.id);
        } catch (e) {
          await queue.markFailed(op.id, e.toString());
        }
      }
    } finally {
      _running = false;
    }
  }

  Future<void> _dispatch(SyncOperationsTableData op) async {
    final payload = op.payload == null
        ? <String, dynamic>{}
        : jsonDecode(op.payload!) as Map<String, dynamic>;

    switch (op.entityType) {
      case 'exercise':
        return _dispatchExercise(op, payload);
      case 'routine':
        return _dispatchRoutine(op, payload);
      case 'workout':
        return _dispatchWorkout(op, payload);
      case 'workout_exercise':
        return _dispatchWorkoutExercise(op, payload);
      case 'workout_set':
        return _dispatchWorkoutSet(op, payload);
      default:
        throw StateError('Unknown sync entity_type: ${op.entityType}');
    }
  }

  Future<void> _dispatchExercise(SyncOperationsTableData op, Map<String, dynamic> payload) async {
    switch (op.operation) {
      case 'create':
        await exerciseRemote.create(Exercise.fromJson(payload));
      case 'update':
        await exerciseRemote.update(Exercise.fromJson(payload));
      case 'delete':
        await exerciseRemote.delete(op.entityId);
      default:
        throw StateError('Unsupported exercise op: ${op.operation}');
    }
  }

  Future<void> _dispatchRoutine(SyncOperationsTableData op, Map<String, dynamic> payload) async {
    switch (op.operation) {
      case 'create':
        await routineRemote.create(Routine.fromJson(payload));
      case 'update':
        await routineRemote.update(Routine.fromJson(payload));
      case 'delete':
        await routineRemote.delete(op.entityId);
      default:
        throw StateError('Unsupported routine op: ${op.operation}');
    }
  }

  Future<void> _dispatchWorkout(SyncOperationsTableData op, Map<String, dynamic> payload) async {
    switch (op.operation) {
      case 'create':
        await workoutRemote.start(routineId: payload['routine_id'] as String?);
      case 'update':
        // Plain field updates (notes/gym_id) are PATCHed elsewhere; queue
        // entries for `update` currently only carry the full payload and we
        // treat them as a no-op for now (server is the source of truth on
        // re-sync via refreshOne). A later iteration can wire PATCH here.
        break;
      case 'delete':
        await workoutRemote.delete(op.entityId);
      case 'finish':
        await workoutRemote.finish(op.entityId);
      default:
        throw StateError('Unsupported workout op: ${op.operation}');
    }
  }

  Future<void> _dispatchWorkoutExercise(
      SyncOperationsTableData op, Map<String, dynamic> payload) async {
    switch (op.operation) {
      case 'create':
        await workoutRemote.addExercise(
          workoutId: payload['workout_id'] as String,
          exerciseId: payload['exercise_id'] as String,
          position: payload['position'] as int,
        );
      case 'delete':
        await workoutRemote.removeExercise(
          workoutId: payload['workout_id'] as String,
          weId: op.entityId,
        );
      default:
        throw StateError('Unsupported workout_exercise op: ${op.operation}');
    }
  }

  Future<void> _dispatchWorkoutSet(
      SyncOperationsTableData op, Map<String, dynamic> payload) async {
    final workoutId = payload['workout_id'] as String;
    final weId = payload['workout_exercise_id'] as String;
    switch (op.operation) {
      case 'create':
        await workoutRemote.logSet(workoutId: workoutId, weId: weId, set: WorkoutSet.fromJson(payload));
      case 'update':
        await workoutRemote.updateSet(workoutId: workoutId, weId: weId, set: WorkoutSet.fromJson(payload));
      case 'delete':
        await workoutRemote.removeSet(workoutId: workoutId, weId: weId, setId: op.entityId);
      default:
        throw StateError('Unsupported workout_set op: ${op.operation}');
    }
  }
}
