import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/core/sync/sync_queue.dart';
import 'package:sheipe_app/features/routine/data/local/routine_local_data_source.dart';
import 'package:sheipe_app/features/routine/data/remote/routine_remote_data_source.dart';
import 'package:sheipe_app/features/routine/data/repositories/routine_repository.dart';
import 'package:sheipe_app/features/routine/domain/entities/routine.dart';
import 'package:sheipe_app/features/routine/domain/entities/routine_exercise.dart';
import 'package:sheipe_app/features/routine/domain/entities/routine_set.dart';

class _FakeRemote extends Mock implements RoutineRemoteDataSource {}

void main() {
  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    registerFallbackValue(const Routine(id: 'fb', name: 'fb', creatorId: 'u'));
  });

  late AppDatabase db;
  late RoutineLocalDataSource local;
  late SyncQueue queue;
  late _FakeRemote remote;
  late RoutineRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = RoutineLocalDataSource(db: db);
    queue = SyncQueue(db: db);
    remote = _FakeRemote();
    repo = RoutineRepository(local: local, remote: remote, queue: queue);
  });

  tearDown(() => db.close());

  Routine seededRoutine() => Routine(
        id: 'r-1',
        name: 'Upper A',
        creatorId: 'u-1',
        exercises: [
          RoutineExercise(
            id: 're-1',
            routineId: 'r-1',
            exerciseId: 'ex-1',
            position: 1,
            sets: const [
              RoutineSet(
                id: 'rs-1',
                routineExerciseId: 're-1',
                setNumber: 1,
                setType: 'working',
                weight: 80.0,
                reps: 8,
                restSeconds: 90,
              ),
            ],
          ),
        ],
      );

  test('watchAll emits routines from Drift', () async {
    await local.upsert(seededRoutine());
    final list = await repo.watchAll().first;
    expect(list, hasLength(1));
    expect(list.first.exercises, hasLength(1));
    expect(list.first.exercises.first.sets, hasLength(1));
  });

  test('create writes Drift first then enqueues a create op', () async {
    final routine = Routine(id: '', name: 'Push Day', creatorId: 'u-1');
    final created = await repo.create(routine);

    expect(created.id, isNotEmpty);
    expect(await local.findById(created.id), isNotNull);
    final pending = await queue.pending();
    expect(pending, hasLength(1));
    expect(pending.first.entityType, 'routine');
    expect(pending.first.operation, 'create');
    verifyNever(() => remote.create(any()));
  });

  test('delete removes from Drift and enqueues a delete op', () async {
    await local.upsert(seededRoutine());
    await repo.delete('r-1');
    expect(await local.findById('r-1'), isNull);
    final pending = await queue.pending();
    expect(pending.where((o) => o.operation == 'delete'), hasLength(1));
  });
}
