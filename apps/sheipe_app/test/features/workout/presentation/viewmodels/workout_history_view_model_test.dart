import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/workout/data/repositories/workout_repository.dart';
import 'package:sheipe_app/features/workout/domain/entities/workout.dart';
import 'package:sheipe_app/features/workout/presentation/viewmodels/workout_history_state.dart';
import 'package:sheipe_app/features/workout/presentation/viewmodels/workout_history_view_model.dart';

class _FakeRepo extends Mock implements WorkoutRepository {}

void main() {
  late _FakeRepo repo;

  setUp(() {
    repo = _FakeRepo();
    when(() => repo.refreshFromRemote()).thenAnswer((_) async {});
  });

  blocTest<WorkoutHistoryViewModel, WorkoutHistoryState>(
    'loadHistory emits Loading then Loaded',
    build: () {
      when(() => repo.watchAll(userId: any(named: 'userId'))).thenAnswer((_) => Stream.value([
            Workout(id: 'w1', userId: 'u-1', startedAt: DateTime(2026, 5, 3)),
            Workout(id: 'w2', userId: 'u-1', startedAt: DateTime(2026, 5, 2)),
          ]));
      return WorkoutHistoryViewModel(repository: repo);
    },
    act: (vm) => vm.loadHistory(),
    expect: () => [
      isA<WorkoutHistoryLoading>(),
      predicate<WorkoutHistoryLoaded>((s) => s.items.length == 2),
    ],
  );

  test('deleteWorkout delegates to repository', () async {
    final vm = WorkoutHistoryViewModel(repository: repo);
    when(() => repo.delete(any())).thenAnswer((_) async {});
    await vm.deleteWorkout('w1');
    verify(() => repo.delete('w1')).called(1);
  });
}
