import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/workout/data/repositories/workout_repository.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout_exercise.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout_set.dart';
import 'package:sheipe_app/features/workout/presentation/viewmodels/active_workout_state.dart';
import 'package:sheipe_app/features/workout/presentation/viewmodels/active_workout_view_model.dart';

class _FakeRepo extends Mock implements WorkoutRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Workout(id: 'fb', userId: 'u', startedAt: DateTime(2026, 5, 3)));
    registerFallbackValue(const WorkoutSet(id: 'fb', workoutExerciseId: 'fb-we', setNumber: 1));
  });

  late _FakeRepo repo;
  Workout sample({DateTime? finishedAt, List<WorkoutExercise> exercises = const []}) => Workout(
        id: 'w-1',
        userId: 'u-1',
        startedAt: DateTime(2026, 5, 3),
        finishedAt: finishedAt,
        exercises: exercises,
      );

  setUp(() {
    repo = _FakeRepo();
    when(() => repo.watchById(any())).thenAnswer((_) => Stream.value(sample()));
  });

  test('startWorkout (free) emits Loading then settles InProgress', () async {
    when(() => repo.startFreeWorkout(userId: any(named: 'userId')))
        .thenAnswer((_) async => sample());
    final vm = ActiveWorkoutViewModel(repository: repo);
    final emitted = <ActiveWorkoutState>[];
    final sub = vm.stream.listen(emitted.add);
    await vm.startWorkout(userId: 'u-1');
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted.first, isA<ActiveWorkoutLoading>());
    expect(emitted.last, isA<ActiveWorkoutInProgress>());
    expect((emitted.last as ActiveWorkoutInProgress).workout.id, 'w-1');
  });

  blocTest<ActiveWorkoutViewModel, ActiveWorkoutState>(
    'addExercise routes to repository with next position',
    build: () {
      when(() => repo.startFreeWorkout(userId: any(named: 'userId')))
          .thenAnswer((_) async => sample());
      when(() => repo.addExercise(
            workoutId: any(named: 'workoutId'),
            exerciseId: any(named: 'exerciseId'),
            position: any(named: 'position'),
          )).thenAnswer((_) async => const WorkoutExercise(
                id: 'we-1', workoutId: 'w-1', exerciseId: 'ex-1', position: 1,
              ));
      return ActiveWorkoutViewModel(repository: repo);
    },
    act: (vm) async {
      await vm.startWorkout(userId: 'u-1');
      await vm.addExercise(exerciseId: 'ex-1');
    },
    verify: (_) {
      verify(() => repo.addExercise(workoutId: 'w-1', exerciseId: 'ex-1', position: 1)).called(1);
    },
  );

  test('logSet delegates to repository.logActiveSet', () async {
    when(() => repo.startFreeWorkout(userId: any(named: 'userId')))
        .thenAnswer((_) async => sample());
    when(() => repo.logActiveSet(workoutId: any(named: 'workoutId'), set: any(named: 'set')))
        .thenAnswer((inv) async => (inv.namedArguments[#set] as WorkoutSet).copyWith(id: 's-1'));
    final vm = ActiveWorkoutViewModel(repository: repo);
    await vm.startWorkout(userId: 'u-1');
    final saved = await vm.logSet(
      workoutExerciseId: 'we-1',
      setNumber: 1,
      weight: 100,
      reps: 5,
      rpe: 8,
    );
    expect(saved?.id, 's-1');
  });

  test('updateSet delegates to repository.updateActiveSet', () async {
    when(() => repo.startFreeWorkout(userId: any(named: 'userId')))
        .thenAnswer((_) async => sample());
    when(() => repo.updateActiveSet(workoutId: any(named: 'workoutId'), set: any(named: 'set')))
        .thenAnswer((inv) async => inv.namedArguments[#set] as WorkoutSet);
    final vm = ActiveWorkoutViewModel(repository: repo);
    await vm.startWorkout(userId: 'u-1');
    await vm.updateSet(const WorkoutSet(id: 's-1', workoutExerciseId: 'we-1', setNumber: 1, completed: true));
    verify(() => repo.updateActiveSet(workoutId: 'w-1', set: any(named: 'set'))).called(1);
  });

  test('finishWorkout transitions to Finished', () async {
    when(() => repo.startFreeWorkout(userId: any(named: 'userId')))
        .thenAnswer((_) async => sample());
    when(() => repo.finish(any()))
        .thenAnswer((_) async => sample(finishedAt: DateTime(2026, 5, 3, 13)));
    final vm = ActiveWorkoutViewModel(repository: repo);
    await vm.startWorkout(userId: 'u-1');
    await vm.finishWorkout();
    expect(vm.state, isA<ActiveWorkoutFinished>());
  });

  test('startRestTimer/clearRestTimer adjust currentRestSeconds', () async {
    when(() => repo.startFreeWorkout(userId: any(named: 'userId')))
        .thenAnswer((_) async => sample());
    final vm = ActiveWorkoutViewModel(repository: repo);
    await vm.startWorkout(userId: 'u-1');
    vm.startRestTimer(60);
    expect((vm.state as ActiveWorkoutInProgress).currentRestSeconds, 60);
    vm.clearRestTimer();
    expect((vm.state as ActiveWorkoutInProgress).currentRestSeconds, 0);
  });
}
