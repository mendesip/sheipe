import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/routine_repository.dart';
import '../../domain/entities/routine.dart';
import '../../domain/entities/routine_exercise.dart';
import '../../domain/entities/routine_set.dart';
import 'routine_state.dart';

class RoutineViewModel extends Cubit<RoutineState> {
  RoutineViewModel({required RoutineRepository repository, Uuid? uuid})
      : _repository = repository,
        _uuid = uuid ?? const Uuid(),
        super(const RoutineInitial());

  final RoutineRepository _repository;
  final Uuid _uuid;
  StreamSubscription<List<Routine>>? _streamSub;

  Future<void> loadRoutines() async {
    emit(const RoutineLoading());
    await _streamSub?.cancel();
    _streamSub = _repository.watchAll().listen(
      (items) => emit(RoutineLoaded(items)),
      onError: (Object e) => emit(RoutineError(e.toString())),
    );
    try {
      await _repository.refreshFromRemote();
    } catch (_) {}
  }

  Future<Routine> createRoutine({required String name, required String creatorId, String? description}) {
    return _repository.create(Routine(
      id: '',
      name: name,
      creatorId: creatorId,
      description: description,
    ));
  }

  Future<Routine> addExercise({
    required Routine routine,
    required String exerciseId,
    required int position,
  }) async {
    final newRe = RoutineExercise(
      id: _uuid.v4(),
      routineId: routine.id,
      exerciseId: exerciseId,
      position: position,
    );
    final updated = routine.copyWith(exercises: [...routine.exercises, newRe]);
    return _repository.update(updated);
  }

  Future<Routine> addSet({
    required Routine routine,
    required RoutineExercise re,
    required RoutineSet set,
  }) async {
    final stamped = set.copyWith(id: set.id.isEmpty ? _uuid.v4() : set.id);
    final updatedRe = re.copyWith(sets: [...re.sets, stamped]);
    final updatedRoutine = routine.copyWith(
      exercises: routine.exercises.map((e) => e.id == re.id ? updatedRe : e).toList(),
    );
    return _repository.update(updatedRoutine);
  }

  Future<void> deleteRoutine(String id) => _repository.delete(id);

  @override
  Future<void> close() async {
    await _streamSub?.cancel();
    return super.close();
  }
}
