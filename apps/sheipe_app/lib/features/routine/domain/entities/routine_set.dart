class RoutineSet {
  const RoutineSet({
    required this.id,
    required this.routineExerciseId,
    required this.setNumber,
    required this.setType,
    this.weight,
    this.reps,
    this.restSeconds,
  });

  final String id;
  final String routineExerciseId;
  final int setNumber;
  final String setType;
  final double? weight;
  final int? reps;
  final int? restSeconds;

  factory RoutineSet.fromJson(Map<String, dynamic> json) => RoutineSet(
        id: json['id'] as String,
        routineExerciseId: json['routine_exercise_id'] as String,
        setNumber: json['set_number'] as int,
        setType: (json['set_type'] as String?) ?? 'working',
        weight: (json['weight'] as num?)?.toDouble(),
        reps: json['reps'] as int?,
        restSeconds: json['rest_seconds'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'routine_exercise_id': routineExerciseId,
        'set_number': setNumber,
        'set_type': setType,
        'weight': weight,
        'reps': reps,
        'rest_seconds': restSeconds,
      };

  RoutineSet copyWith({
    String? id,
    String? routineExerciseId,
    int? setNumber,
    String? setType,
    double? weight,
    int? reps,
    int? restSeconds,
  }) =>
      RoutineSet(
        id: id ?? this.id,
        routineExerciseId: routineExerciseId ?? this.routineExerciseId,
        setNumber: setNumber ?? this.setNumber,
        setType: setType ?? this.setType,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        restSeconds: restSeconds ?? this.restSeconds,
      );
}
