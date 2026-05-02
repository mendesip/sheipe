import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../domain/entities/exercise.dart';
import 'exercise_state.dart';

class ExerciseViewModel extends Cubit<ExerciseState> {
  ExerciseViewModel({required ExerciseRepository repository})
      : _repository = repository,
        super(const ExerciseInitial());

  final ExerciseRepository _repository;
  StreamSubscription<List<Exercise>>? _streamSub;

  Future<void> loadExercises({
    String? muscleGroup,
    String? category,
    String? query,
  }) async {
    emit(const ExerciseLoading());
    await _streamSub?.cancel();
    _streamSub = _repository
        .watchAll(muscleGroup: muscleGroup, category: category, query: query)
        .listen(
      (items) {
        emit(ExerciseLoaded(
          items: items,
          muscleGroup: muscleGroup,
          category: category,
          query: query,
        ));
      },
      onError: (Object e) => emit(ExerciseError(e.toString())),
    );
    try {
      await _repository.refreshFromRemote(
        muscleGroup: muscleGroup,
        category: category,
        query: query,
      );
    } catch (_) {
      // We already show cached data; ignore network errors here.
    }
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    return _repository.create(exercise);
  }

  Future<void> deleteExercise(String id) async {
    await _repository.delete(id);
  }

  @override
  Future<void> close() async {
    await _streamSub?.cancel();
    return super.close();
  }
}
