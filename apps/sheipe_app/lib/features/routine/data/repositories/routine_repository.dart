import 'package:uuid/uuid.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../domain/entities/routine.dart';
import '../local/routine_local_data_source.dart';
import '../remote/routine_remote_data_source.dart';

class RoutineRepository {
  RoutineRepository({
    required this.local,
    required this.remote,
    required this.queue,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final RoutineLocalDataSource local;
  final RoutineRemoteDataSource remote;
  final SyncQueue queue;
  final Uuid _uuid;

  Stream<List<Routine>> watchAll({String? creatorId}) =>
      local.watchAll(creatorId: creatorId);

  Stream<Routine?> watchById(String id) => local.watchById(id);

  Future<Routine?> findById(String id) => local.findById(id);

  Future<Routine> create(Routine routine) async {
    final withId = routine.id.isEmpty
        ? routine.copyWith(id: _uuid.v4(), createdAt: DateTime.now())
        : routine;
    await local.upsert(withId);
    await queue.enqueue(
      entityType: 'routine',
      entityId: withId.id,
      operation: SyncOp.create,
      payload: withId.toJson(),
    );
    return withId;
  }

  Future<Routine> update(Routine routine) async {
    final stamped = routine.copyWith(updatedAt: DateTime.now());
    await local.upsert(stamped);
    await queue.enqueue(
      entityType: 'routine',
      entityId: stamped.id,
      operation: SyncOp.update,
      payload: stamped.toJson(),
    );
    return stamped;
  }

  Future<void> delete(String id) async {
    await local.deleteById(id);
    await queue.enqueue(
      entityType: 'routine',
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
