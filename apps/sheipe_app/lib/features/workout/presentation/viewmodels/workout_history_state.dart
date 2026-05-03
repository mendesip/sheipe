import '../../domain/entities/workout.dart';

sealed class WorkoutHistoryState {
  const WorkoutHistoryState();
}

final class WorkoutHistoryInitial extends WorkoutHistoryState {
  const WorkoutHistoryInitial();
}

final class WorkoutHistoryLoading extends WorkoutHistoryState {
  const WorkoutHistoryLoading();
}

final class WorkoutHistoryLoaded extends WorkoutHistoryState {
  const WorkoutHistoryLoaded(this.items);
  final List<Workout> items;
}

final class WorkoutHistoryError extends WorkoutHistoryState {
  const WorkoutHistoryError(this.message);
  final String message;
}
