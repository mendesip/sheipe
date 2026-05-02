import 'routine_set.dart';

class RoutineExercise {
  const RoutineExercise({
    required this.id,
    required this.routineId,
    required this.exerciseId,
    required this.position,
    this.notes,
    this.sets = const [],
  });

  final String id;
  final String routineId;
  final String exerciseId;
  final int position;
  final String? notes;
  final List<RoutineSet> sets;

  factory RoutineExercise.fromJson(Map<String, dynamic> json) => RoutineExercise(
        id: json['id'] as String,
        routineId: json['routine_id'] as String,
        exerciseId: json['exercise_id'] as String,
        position: json['position'] as int,
        notes: json['notes'] as String?,
        sets: ((json['sets'] as List<dynamic>?) ?? const [])
            .map((s) => RoutineSet.fromJson(s as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'routine_id': routineId,
        'exercise_id': exerciseId,
        'position': position,
        'notes': notes,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  RoutineExercise copyWith({
    String? id,
    String? routineId,
    String? exerciseId,
    int? position,
    String? notes,
    List<RoutineSet>? sets,
  }) =>
      RoutineExercise(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        exerciseId: exerciseId ?? this.exerciseId,
        position: position ?? this.position,
        notes: notes ?? this.notes,
        sets: sets ?? this.sets,
      );
}
