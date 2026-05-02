import 'workout_set.dart';

class WorkoutExercise {
  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.position,
    this.routineExerciseId,
    this.notes,
    this.sets = const [],
  });

  final String id;
  final String workoutId;
  final String exerciseId;
  final int position;
  final String? routineExerciseId;
  final String? notes;
  final List<WorkoutSet> sets;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) => WorkoutExercise(
        id: json['id'] as String,
        workoutId: json['workout_id'] as String,
        exerciseId: json['exercise_id'] as String,
        position: json['position'] as int,
        routineExerciseId: json['routine_exercise_id'] as String?,
        notes: json['notes'] as String?,
        sets: ((json['sets'] as List<dynamic>?) ?? const [])
            .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'workout_id': workoutId,
        'exercise_id': exerciseId,
        'position': position,
        'routine_exercise_id': routineExerciseId,
        'notes': notes,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  WorkoutExercise copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    int? position,
    String? routineExerciseId,
    String? notes,
    List<WorkoutSet>? sets,
  }) =>
      WorkoutExercise(
        id: id ?? this.id,
        workoutId: workoutId ?? this.workoutId,
        exerciseId: exerciseId ?? this.exerciseId,
        position: position ?? this.position,
        routineExerciseId: routineExerciseId ?? this.routineExerciseId,
        notes: notes ?? this.notes,
        sets: sets ?? this.sets,
      );
}
