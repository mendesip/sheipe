class WorkoutSet {
  const WorkoutSet({
    required this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    this.weight,
    this.reps,
    this.rpe,
    this.completed = false,
    this.notes,
  });

  final String id;
  final String workoutExerciseId;
  final int setNumber;
  final double? weight;
  final int? reps;
  final double? rpe;
  final bool completed;
  final String? notes;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
        id: json['id'] as String,
        workoutExerciseId: json['workout_exercise_id'] as String,
        setNumber: json['set_number'] as int,
        weight: (json['weight'] as num?)?.toDouble(),
        reps: json['reps'] as int?,
        rpe: (json['rpe'] as num?)?.toDouble(),
        completed: (json['completed'] as bool?) ?? false,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'workout_exercise_id': workoutExerciseId,
        'set_number': setNumber,
        'weight': weight,
        'reps': reps,
        'rpe': rpe,
        'completed': completed,
        'notes': notes,
      };

  WorkoutSet copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    double? weight,
    int? reps,
    double? rpe,
    bool? completed,
    String? notes,
  }) =>
      WorkoutSet(
        id: id ?? this.id,
        workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
        setNumber: setNumber ?? this.setNumber,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        rpe: rpe ?? this.rpe,
        completed: completed ?? this.completed,
        notes: notes ?? this.notes,
      );
}
