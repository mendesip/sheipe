import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/core/sync/sync_queue.dart';
import 'package:sheipe_app/core/sync/sync_service.dart';
import 'package:sheipe_app/features/exercise/data/remote/exercise_remote_data_source.dart';
import 'package:sheipe_app/features/exercise/domain/entities/exercise.dart';
import 'package:sheipe_app/features/routine/data/remote/routine_remote_data_source.dart';
import 'package:sheipe_app/features/workout/data/remote/workout_remote_data_source.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout.dart';

class _FakeExerciseRemote extends Mock implements ExerciseRemoteDataSource {}
class _FakeRoutineRemote  extends Mock implements RoutineRemoteDataSource {}
class _FakeWorkoutRemote  extends Mock implements WorkoutRemoteDataSource {}

void main() {
  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    registerFallbackValue(const Exercise(
      id: 'fb', name: 'fb', muscleGroup: 'chest', category: 'strength',
    ));
  });

  late AppDatabase db;
  late SyncQueue queue;
  late _FakeExerciseRemote exRemote;
  late _FakeRoutineRemote roRemote;
  late _FakeWorkoutRemote wkRemote;
  late SyncService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueue(db: db);
    exRemote = _FakeExerciseRemote();
    roRemote = _FakeRoutineRemote();
    wkRemote = _FakeWorkoutRemote();
    service = SyncService(
      queue: queue,
      exerciseRemote: exRemote,
      routineRemote: roRemote,
      workoutRemote: wkRemote,
    );
  });

  tearDown(() => db.close());

  test('drains create-exercise op and marks it synced', () async {
    when(() => exRemote.create(any())).thenAnswer((_) async => const Exercise(
          id: 'srv-1', name: 'Bench', muscleGroup: 'chest', category: 'strength',
        ));

    await queue.enqueue(
      entityType: 'exercise',
      entityId: 'local-1',
      operation: SyncOp.create,
      payload: const {
        'id': 'local-1',
        'name': 'Bench',
        'muscle_group': 'chest',
        'category': 'strength',
        'is_system': false,
      },
    );

    await service.processQueue();

    verify(() => exRemote.create(any())).called(1);
    final pending = await queue.pending();
    expect(pending, isEmpty);
  });

  test('drains delete-exercise op', () async {
    when(() => exRemote.delete(any())).thenAnswer((_) async {});
    await queue.enqueue(
      entityType: 'exercise',
      entityId: 'gone-1',
      operation: SyncOp.delete,
    );
    await service.processQueue();
    verify(() => exRemote.delete('gone-1')).called(1);
  });

  test('drains finish-workout op', () async {
    when(() => wkRemote.finish('w-1')).thenAnswer((_) async => Workout(
          id: 'w-1',
          userId: 'u-1',
          startedAt: DateTime(2026, 5, 2),
          finishedAt: DateTime(2026, 5, 2, 12),
        ));

    await queue.enqueue(
      entityType: 'workout',
      entityId: 'w-1',
      operation: SyncOp.finish,
    );
    await service.processQueue();
    verify(() => wkRemote.finish('w-1')).called(1);
    final pending = await queue.pending();
    expect(pending, isEmpty);
  });

  test('failed operation stays in queue and increments attempt count', () async {
    when(() => exRemote.delete(any())).thenThrow(Exception('boom'));
    await queue.enqueue(
      entityType: 'exercise',
      entityId: 'fail-1',
      operation: SyncOp.delete,
    );
    await service.processQueue();
    final pending = await queue.pending();
    expect(pending, hasLength(1));
    expect(pending.first.attemptCount, 1);
    expect(pending.first.lastError, contains('boom'));
  });
}
