import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/exercise/data/repositories/exercise_repository.dart';
import 'package:sheipe_app/features/exercise/domain/entities/exercise.dart';
import 'package:sheipe_app/features/exercise/presentation/viewmodels/exercise_state.dart';
import 'package:sheipe_app/features/exercise/presentation/viewmodels/exercise_view_model.dart';

class _FakeRepo extends Mock implements ExerciseRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Exercise(
      id: 'fb',
      name: 'fb',
      muscleGroup: 'chest',
      category: 'strength',
    ));
  });

  late _FakeRepo repo;

  setUp(() {
    repo = _FakeRepo();
    when(() => repo.refreshFromRemote(
          muscleGroup: any(named: 'muscleGroup'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        )).thenAnswer((_) async {});
  });

  blocTest<ExerciseViewModel, ExerciseState>(
    'loadExercises emits Loading then Loaded with stream items',
    build: () {
      when(() => repo.watchAll(
            muscleGroup: any(named: 'muscleGroup'),
            category: any(named: 'category'),
            query: any(named: 'query'),
          )).thenAnswer((_) => Stream.value(const [
            Exercise(id: 'e1', name: 'Bench', muscleGroup: 'chest', category: 'strength'),
          ]));
      return ExerciseViewModel(repository: repo);
    },
    act: (vm) => vm.loadExercises(),
    expect: () => [
      isA<ExerciseLoading>(),
      predicate<ExerciseLoaded>(
        (s) => s.items.length == 1 && s.items.first.name == 'Bench',
        'Loaded with one item named Bench',
      ),
    ],
  );

  blocTest<ExerciseViewModel, ExerciseState>(
    'loadExercises with filters propagates them to repository.watchAll',
    build: () {
      when(() => repo.watchAll(
            muscleGroup: any(named: 'muscleGroup'),
            category: any(named: 'category'),
            query: any(named: 'query'),
          )).thenAnswer((_) => Stream.value(const []));
      return ExerciseViewModel(repository: repo);
    },
    act: (vm) => vm.loadExercises(muscleGroup: 'chest'),
    verify: (_) {
      verify(() => repo.watchAll(muscleGroup: 'chest', category: null, query: null)).called(1);
    },
  );

  test('createExercise delegates to repository', () async {
    final vm = ExerciseViewModel(repository: repo);
    when(() => repo.create(any())).thenAnswer((_) async => const Exercise(
          id: 'new',
          name: 'New',
          muscleGroup: 'back',
          category: 'strength',
        ));
    final result = await vm.createExercise(const Exercise(
      id: '',
      name: 'New',
      muscleGroup: 'back',
      category: 'strength',
    ));
    expect(result.id, 'new');
    verify(() => repo.create(any())).called(1);
  });

  test('deleteExercise delegates to repository', () async {
    final vm = ExerciseViewModel(repository: repo);
    when(() => repo.delete(any())).thenAnswer((_) async {});
    await vm.deleteExercise('e1');
    verify(() => repo.delete('e1')).called(1);
  });
}
