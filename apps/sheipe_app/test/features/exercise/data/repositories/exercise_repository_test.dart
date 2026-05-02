import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/core/sync/sync_queue.dart';
import 'package:sheipe_app/features/exercise/data/local/exercise_local_data_source.dart';
import 'package:sheipe_app/features/exercise/data/remote/exercise_remote_data_source.dart';
import 'package:sheipe_app/features/exercise/data/repositories/exercise_repository.dart';
import 'package:sheipe_app/features/exercise/domain/entities/exercise.dart';

class _FakeRemote extends Mock implements ExerciseRemoteDataSource {}

void main() {
  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    registerFallbackValue(const Exercise(
      id: 'fallback',
      name: 'fallback',
      muscleGroup: 'chest',
      category: 'strength',
    ));
  });

  late AppDatabase db;
  late ExerciseLocalDataSource local;
  late SyncQueue queue;
  late _FakeRemote remote;
  late ExerciseRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = ExerciseLocalDataSource(db: db);
    queue = SyncQueue(db: db);
    remote = _FakeRemote();
    repo = ExerciseRepository(local: local, remote: remote, queue: queue);
  });

  tearDown(() => db.close());

  test('watchAll emits the current Drift contents', () async {
    await local.upsert(const Exercise(
      id: 'e1',
      name: 'Bench Press',
      muscleGroup: 'chest',
      category: 'strength',
    ));
    final stream = repo.watchAll();
    final list = await stream.first;
    expect(list, hasLength(1));
    expect(list.first.name, 'Bench Press');
  });

  test('create writes to Drift first then enqueues a sync operation', () async {
    final e = const Exercise(
      id: '',
      name: 'Custom Pull-Up',
      muscleGroup: 'back',
      category: 'strength',
    );
    final created = await repo.create(e);

    expect(created.id, isNotEmpty);
    final fromDrift = await local.findById(created.id);
    expect(fromDrift?.name, 'Custom Pull-Up');

    final pending = await queue.pending();
    expect(pending, hasLength(1));
    expect(pending.first.entityType, 'exercise');
    expect(pending.first.operation, 'create');

    verifyNever(() => remote.create(any()));
  });

  test('delete removes from Drift and enqueues a delete operation', () async {
    await local.upsert(const Exercise(
      id: 'd1',
      name: 'Doomed',
      muscleGroup: 'chest',
      category: 'strength',
    ));
    await repo.delete('d1');

    expect(await local.findById('d1'), isNull);
    final pending = await queue.pending();
    expect(pending, hasLength(1));
    expect(pending.first.operation, 'delete');
    expect(pending.first.entityId, 'd1');
  });

  test('refreshFromRemote pulls list and upserts into Drift', () async {
    when(() => remote.getAll(
          muscleGroup: any(named: 'muscleGroup'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        )).thenAnswer((_) async => const [
          Exercise(id: 'r1', name: 'Squat', muscleGroup: 'legs', category: 'strength'),
        ]);
    await repo.refreshFromRemote();
    final all = await repo.watchAll().first;
    expect(all.map((e) => e.id), contains('r1'));
  });
}
