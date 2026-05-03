import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/workout_repository.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_set.dart';
import 'active_workout_state.dart';

class ActiveWorkoutViewModel extends Cubit<ActiveWorkoutState> {
  ActiveWorkoutViewModel({required WorkoutRepository repository})
      : _repository = repository,
        super(const ActiveWorkoutInitial());

  final WorkoutRepository _repository;
  StreamSubscription<Workout?>? _subscription;

  Future<void> startWorkout({required String userId, String? routineId}) async {
    emit(const ActiveWorkoutLoading());
    try {
      final w = routineId == null
          ? await _repository.startFreeWorkout(userId: userId)
          : await _repository.startFromRoutine(userId: userId, routineId: routineId);
      _subscribe(w.id);
      emit(ActiveWorkoutInProgress(workout: w));
    } catch (e) {
      emit(ActiveWorkoutError(e.toString()));
    }
  }

  /// Re-attaches to an existing workout (e.g. after process death).
  Future<void> resume(String workoutId) async {
    emit(const ActiveWorkoutLoading());
    final w = await _repository.findById(workoutId);
    if (w == null) {
      emit(const ActiveWorkoutError('Workout not found'));
      return;
    }
    _subscribe(w.id);
    if (w.finishedAt == null) {
      emit(ActiveWorkoutInProgress(workout: w));
    } else {
      emit(ActiveWorkoutFinished(w));
    }
  }

  void _subscribe(String id) {
    _subscription?.cancel();
    _subscription = _repository.watchById(id).listen((workout) {
      if (workout == null) return;
      final current = state;
      if (current is ActiveWorkoutInProgress) {
        emit(current.copyWith(workout: workout));
      }
    });
  }

  Future<void> addExercise({required String exerciseId}) async {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;
    final position = current.workout.exercises.length + 1;
    await _repository.addExercise(
      workoutId: current.workout.id,
      exerciseId: exerciseId,
      position: position,
    );
  }

  Future<WorkoutSet?> logSet({
    required String workoutExerciseId,
    required int setNumber,
    double? weight,
    int? reps,
    double? rpe,
    bool completed = true,
  }) async {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return null;
    final set = WorkoutSet(
      id: '',
      workoutExerciseId: workoutExerciseId,
      setNumber: setNumber,
      weight: weight,
      reps: reps,
      rpe: rpe,
      completed: completed,
    );
    return _repository.logActiveSet(workoutId: current.workout.id, set: set);
  }

  Future<void> updateSet(WorkoutSet set) async {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;
    await _repository.updateActiveSet(workoutId: current.workout.id, set: set);
  }

  void startRestTimer(int seconds) {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;
    emit(current.copyWith(currentRestSeconds: seconds));
  }

  void clearRestTimer() {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;
    emit(current.copyWith(currentRestSeconds: 0));
  }

  Future<void> finishWorkout() async {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;
    final finished = await _repository.finish(current.workout.id);
    emit(ActiveWorkoutFinished(finished));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
