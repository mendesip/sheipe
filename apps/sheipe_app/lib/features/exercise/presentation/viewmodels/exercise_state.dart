import '../../domain/entities/exercise.dart';

sealed class ExerciseState {
  const ExerciseState();
}

final class ExerciseInitial extends ExerciseState {
  const ExerciseInitial();
}

final class ExerciseLoading extends ExerciseState {
  const ExerciseLoading();
}

final class ExerciseLoaded extends ExerciseState {
  const ExerciseLoaded({
    required this.items,
    this.muscleGroup,
    this.category,
    this.query,
  });

  final List<Exercise> items;
  final String? muscleGroup;
  final String? category;
  final String? query;

  ExerciseLoaded copyWith({
    List<Exercise>? items,
    String? muscleGroup,
    String? category,
    String? query,
  }) =>
      ExerciseLoaded(
        items: items ?? this.items,
        muscleGroup: muscleGroup ?? this.muscleGroup,
        category: category ?? this.category,
        query: query ?? this.query,
      );
}

final class ExerciseError extends ExerciseState {
  const ExerciseError(this.message);
  final String message;
}
