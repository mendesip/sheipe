import 'workout_exercise.dart';

class Workout {
  const Workout({
    required this.id,
    required this.userId,
    required this.startedAt,
    this.routineId,
    this.gymId,
    this.finishedAt,
    this.notes,
    this.trainerNotes,
    this.exercises = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final DateTime startedAt;
  final String? routineId;
  final String? gymId;
  final DateTime? finishedAt;
  final String? notes;
  final String? trainerNotes;
  final List<WorkoutExercise> exercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isInProgress => finishedAt == null;

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        startedAt: DateTime.parse(json['started_at'] as String),
        routineId: json['routine_id'] as String?,
        gymId: json['gym_id'] as String?,
        finishedAt: _parse(json['finished_at']),
        notes: json['notes'] as String?,
        trainerNotes: json['trainer_notes'] as String?,
        exercises: ((json['exercises'] as List<dynamic>?) ?? const [])
            .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: _parse(json['created_at']),
        updatedAt: _parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'started_at': startedAt.toIso8601String(),
        'routine_id': routineId,
        'gym_id': gymId,
        if (finishedAt != null) 'finished_at': finishedAt!.toIso8601String(),
        'notes': notes,
        'trainer_notes': trainerNotes,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  Workout copyWith({
    String? id,
    String? userId,
    DateTime? startedAt,
    String? routineId,
    String? gymId,
    DateTime? finishedAt,
    String? notes,
    String? trainerNotes,
    List<WorkoutExercise>? exercises,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Workout(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        startedAt: startedAt ?? this.startedAt,
        routineId: routineId ?? this.routineId,
        gymId: gymId ?? this.gymId,
        finishedAt: finishedAt ?? this.finishedAt,
        notes: notes ?? this.notes,
        trainerNotes: trainerNotes ?? this.trainerNotes,
        exercises: exercises ?? this.exercises,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static DateTime? _parse(Object? v) => v is String ? DateTime.tryParse(v) : null;
}
