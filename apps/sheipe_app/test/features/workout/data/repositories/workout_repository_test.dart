import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/core/sync/sync_queue.dart';
import 'package:sheipe_app/features/workout/data/local/workout_local_data_source.dart';
import 'package:sheipe_app/features/workout/data/remote/workout_remote_data_source.dart';
import 'package:sheipe_app/features/workout/data/repositories/workout_repository.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout_exercise.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout_set.dart';

class _FakeRemote extends Mock implements WorkoutRemoteDataSource {}

void main() {
  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    registerFallbackValue(Workout(id: 'fb', userId: 'u', startedAt: DateTime(2026, 5, 2)));
    registerFallbackValue(const WorkoutSet(
      id: 'fb',
      workoutExerciseId: 'fb-we',
      setNumber: 1,
    ));
  });

  late AppDatabase db;
  late WorkoutLocalDataSource local;
  late SyncQueue queue;
  late _FakeRemote remote;
  late WorkoutRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = WorkoutLocalDataSource(db: db);
    queue = SyncQueue(db: db);
    remote = _FakeRemote();
    repo = WorkoutRepository(local: local, remote: remote, queue: queue);
  });

  tearDown(() => db.close());

  test('startFreeWorkout writes to Drift first and enqueues a create op', () async {
    final w = await repo.startFreeWorkout(userId: 'u-1');
    expect(w.id, isNotEmpty);
    expect(await local.findById(w.id), isNotNull);
    final pending = await queue.pending();
    expect(pending, hasLength(1));
    expect(pending.first.entityType, 'workout');
    expect(pending.first.operation, 'create');
    verifyNever(() => remote.start(routineId: any(named: 'routineId')));
  });

  test('logActiveSet writes Drift AND fires fire-and-forget remote call', () async {
    // Seed a workout with one exercise so the set can attach
    final workout = Workout(
      id: 'w-1',
      userId: 'u-1',
      startedAt: DateTime(2026, 5, 2),
      exercises: [
        const WorkoutExercise(
          id: 'we-1',
          workoutId: 'w-1',
          exerciseId: 'ex-1',
          position: 1,
        ),
      ],
    );
    await local.upsert(workout);

    when(() => remote.logSet(
          workoutId: any(named: 'workoutId'),
          weId: any(named: 'weId'),
          set: any(named: 'set'),
        )).thenAnswer((_) async => const WorkoutSet(
          id: 's-1',
          workoutExerciseId: 'we-1',
          setNumber: 1,
        ));

    final set = const WorkoutSet(
      id: '',
      workoutExerciseId: 'we-1',
      setNumber: 1,
      weight: 100.0,
      reps: 5,
      rpe: 8.0,
      completed: true,
    );
    final saved = await repo.logActiveSet(workoutId: 'w-1', set: set);

    expect(saved.id, isNotEmpty);

    // Active-workout sets do not enter the queue
    final pending = await queue.pending();
    expect(pending, isEmpty);

    // Fire-and-forget: give the microtask a tick to fire
    await Future<void>.delayed(Duration.zero);
    verify(() => remote.logSet(
          workoutId: 'w-1',
          weId: 'we-1',
          set: any(named: 'set'),
        )).called(1);
  });

  test('finish marks finishedAt locally and enqueues update op', () async {
    final workout = Workout(
      id: 'w-2',
      userId: 'u-1',
      startedAt: DateTime(2026, 5, 2),
    );
    await local.upsert(workout);
    final finished = await repo.finish('w-2');
    expect(finished.finishedAt, isNotNull);
    final stored = await local.findById('w-2');
    expect(stored?.finishedAt, isNotNull);
    final pending = await queue.pending();
    expect(pending.where((o) => o.entityType == 'workout' && o.operation == 'finish'), hasLength(1));
  });
}
