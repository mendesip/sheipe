import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/workout_repository.dart';
import '../../domain/entities/workout.dart';
import 'workout_history_state.dart';

class WorkoutHistoryViewModel extends Cubit<WorkoutHistoryState> {
  WorkoutHistoryViewModel({required WorkoutRepository repository})
      : _repository = repository,
        super(const WorkoutHistoryInitial());

  final WorkoutRepository _repository;
  StreamSubscription<List<Workout>>? _subscription;

  Future<void> loadHistory({String? userId}) async {
    emit(const WorkoutHistoryLoading());
    await _subscription?.cancel();
    _subscription = _repository.watchAll(userId: userId).listen(
      (items) => emit(WorkoutHistoryLoaded(items)),
      onError: (Object e) => emit(WorkoutHistoryError(e.toString())),
    );
    try {
      await _repository.refreshFromRemote();
    } catch (_) {}
  }

  Future<void> deleteWorkout(String id) => _repository.delete(id);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
