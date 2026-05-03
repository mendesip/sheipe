import '../../domain/entities/workout.dart';

sealed class ActiveWorkoutState {
  const ActiveWorkoutState();
}

final class ActiveWorkoutInitial extends ActiveWorkoutState {
  const ActiveWorkoutInitial();
}

final class ActiveWorkoutLoading extends ActiveWorkoutState {
  const ActiveWorkoutLoading();
}

final class ActiveWorkoutInProgress extends ActiveWorkoutState {
  const ActiveWorkoutInProgress({
    required this.workout,
    this.currentRestSeconds = 0,
  });

  final Workout workout;
  final int currentRestSeconds;

  ActiveWorkoutInProgress copyWith({
    Workout? workout,
    int? currentRestSeconds,
  }) =>
      ActiveWorkoutInProgress(
        workout: workout ?? this.workout,
        currentRestSeconds: currentRestSeconds ?? this.currentRestSeconds,
      );
}

final class ActiveWorkoutFinished extends ActiveWorkoutState {
  const ActiveWorkoutFinished(this.workout);
  final Workout workout;
}

final class ActiveWorkoutError extends ActiveWorkoutState {
  const ActiveWorkoutError(this.message);
  final String message;
}
