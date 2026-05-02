import 'routine_exercise.dart';

class Routine {
  const Routine({
    required this.id,
    required this.name,
    required this.creatorId,
    this.description,
    this.isTemplate = false,
    this.exercises = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String creatorId;
  final String? description;
  final bool isTemplate;
  final List<RoutineExercise> exercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
        id: json['id'] as String,
        name: json['name'] as String,
        creatorId: json['creator_id'] as String,
        description: json['description'] as String?,
        isTemplate: (json['is_template'] as bool?) ?? false,
        exercises: ((json['exercises'] as List<dynamic>?) ?? const [])
            .map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: _parse(json['created_at']),
        updatedAt: _parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'creator_id': creatorId,
        'description': description,
        'is_template': isTemplate,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  Routine copyWith({
    String? id,
    String? name,
    String? creatorId,
    String? description,
    bool? isTemplate,
    List<RoutineExercise>? exercises,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Routine(
        id: id ?? this.id,
        name: name ?? this.name,
        creatorId: creatorId ?? this.creatorId,
        description: description ?? this.description,
        isTemplate: isTemplate ?? this.isTemplate,
        exercises: exercises ?? this.exercises,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static DateTime? _parse(Object? v) => v is String ? DateTime.tryParse(v) : null;
}
