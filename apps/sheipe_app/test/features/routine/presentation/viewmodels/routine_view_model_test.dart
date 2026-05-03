import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/routine/data/repositories/routine_repository.dart';
import 'package:sheipe_app/features/routine/domain/entities/routine.dart';
import 'package:sheipe_app/features/routine/domain/entities/routine_exercise.dart';
import 'package:sheipe_app/features/routine/domain/entities/routine_set.dart';
import 'package:sheipe_app/features/routine/presentation/viewmodels/routine_state.dart';
import 'package:sheipe_app/features/routine/presentation/viewmodels/routine_view_model.dart';

class _FakeRepo extends Mock implements RoutineRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Routine(id: 'fb', name: 'fb', creatorId: 'u'));
  });

  late _FakeRepo repo;

  setUp(() {
    repo = _FakeRepo();
    when(() => repo.refreshFromRemote()).thenAnswer((_) async {});
  });

  blocTest<RoutineViewModel, RoutineState>(
    'loadRoutines emits Loading then Loaded',
    build: () {
      when(() => repo.watchAll(creatorId: any(named: 'creatorId')))
          .thenAnswer((_) => Stream.value(const [Routine(id: 'r1', name: 'A', creatorId: 'u1')]));
      return RoutineViewModel(repository: repo);
    },
    act: (vm) => vm.loadRoutines(),
    expect: () => [
      isA<RoutineLoading>(),
      predicate<RoutineLoaded>((s) => s.items.length == 1 && s.items.first.name == 'A'),
    ],
  );

  test('createRoutine delegates to repository.create', () async {
    final vm = RoutineViewModel(repository: repo);
    when(() => repo.create(any())).thenAnswer((inv) async =>
        (inv.positionalArguments.first as Routine).copyWith(id: 'srv'));
    final r = await vm.createRoutine(name: 'New', creatorId: 'u1');
    expect(r.id, 'srv');
  });

  test('addExercise appends exercise to routine and updates', () async {
    final vm = RoutineViewModel(repository: repo);
    final routine = const Routine(id: 'r-1', name: 'A', creatorId: 'u1');
    when(() => repo.update(any())).thenAnswer((inv) async => inv.positionalArguments.first as Routine);
    final updated = await vm.addExercise(routine: routine, exerciseId: 'ex-1', position: 1);
    expect(updated.exercises, hasLength(1));
    expect(updated.exercises.first.exerciseId, 'ex-1');
  });

  test('addSet appends set to the routine exercise', () async {
    final vm = RoutineViewModel(repository: repo);
    final re = const RoutineExercise(id: 're-1', routineId: 'r-1', exerciseId: 'ex-1', position: 1);
    final routine = Routine(id: 'r-1', name: 'A', creatorId: 'u1', exercises: [re]);
    when(() => repo.update(any())).thenAnswer((inv) async => inv.positionalArguments.first as Routine);
    final updated = await vm.addSet(
      routine: routine,
      re: re,
      set: const RoutineSet(id: '', routineExerciseId: 're-1', setNumber: 1, setType: 'working'),
    );
    expect(updated.exercises.first.sets, hasLength(1));
    expect(updated.exercises.first.sets.first.id, isNotEmpty);
  });

  test('deleteRoutine delegates to repository.delete', () async {
    final vm = RoutineViewModel(repository: repo);
    when(() => repo.delete(any())).thenAnswer((_) async {});
    await vm.deleteRoutine('r-1');
    verify(() => repo.delete('r-1')).called(1);
  });
}
