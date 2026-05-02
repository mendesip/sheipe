class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.category,
    this.description,
    this.isSystem = false,
    this.creatorId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String muscleGroup;
  final String category;
  final String? description;
  final bool isSystem;
  final String? creatorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        muscleGroup: json['muscle_group'] as String,
        category: json['category'] as String,
        description: json['description'] as String?,
        isSystem: (json['is_system'] as bool?) ?? false,
        creatorId: json['creator_id'] as String?,
        createdAt: _parse(json['created_at']),
        updatedAt: _parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscle_group': muscleGroup,
        'category': category,
        'description': description,
        'is_system': isSystem,
        'creator_id': creatorId,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  Exercise copyWith({
    String? id,
    String? name,
    String? muscleGroup,
    String? category,
    String? description,
    bool? isSystem,
    String? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        muscleGroup: muscleGroup ?? this.muscleGroup,
        category: category ?? this.category,
        description: description ?? this.description,
        isSystem: isSystem ?? this.isSystem,
        creatorId: creatorId ?? this.creatorId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static DateTime? _parse(Object? v) => v is String ? DateTime.tryParse(v) : null;
}
