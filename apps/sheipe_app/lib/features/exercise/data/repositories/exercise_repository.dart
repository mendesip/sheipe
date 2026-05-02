import 'package:uuid/uuid.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../domain/entities/exercise.dart';
import '../local/exercise_local_data_source.dart';
import '../remote/exercise_remote_data_source.dart';

/// Offline-first repository for exercises.
///
/// Reads always come from Drift via [watchAll]. Writes go to Drift first,
/// then enqueue a sync operation that the [SyncService] drains in the
/// background.
class ExerciseRepository {
  ExerciseRepository({
    required this.local,
    required this.remote,
    required this.queue,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final ExerciseLocalDataSource local;
  final ExerciseRemoteDataSource remote;
  final SyncQueue queue;
  final Uuid _uuid;

  Stream<List<Exercise>> watchAll({
    String? muscleGroup,
    String? category,
    String? query,
  }) =>
      local.watchAll(muscleGroup: muscleGroup, category: category, query: query);

  Future<Exercise?> findById(String id) => local.findById(id);

  Future<Exercise> create(Exercise exercise) async {
    final withId = exercise.id.isEmpty
        ? exercise.copyWith(id: _uuid.v4(), createdAt: DateTime.now())
        : exercise;
    await local.upsert(withId);
    await queue.enqueue(
      entityType: 'exercise',
      entityId: withId.id,
      operation: SyncOp.create,
      payload: withId.toJson(),
    );
    return withId;
  }

  Future<Exercise> update(Exercise exercise) async {
    final stamped = exercise.copyWith(updatedAt: DateTime.now());
    await local.upsert(stamped);
    await queue.enqueue(
      entityType: 'exercise',
      entityId: stamped.id,
      operation: SyncOp.update,
      payload: stamped.toJson(),
    );
    return stamped;
  }

  Future<void> delete(String id) async {
    await local.deleteById(id);
    await queue.enqueue(
      entityType: 'exercise',
      entityId: id,
      operation: SyncOp.delete,
    );
  }

  Future<void> refreshFromRemote({
    String? muscleGroup,
    String? category,
    String? query,
  }) async {
    final remoteList = await remote.getAll(
      muscleGroup: muscleGroup,
      category: category,
      query: query,
    );
    await local.upsertAll(remoteList);
  }
}
