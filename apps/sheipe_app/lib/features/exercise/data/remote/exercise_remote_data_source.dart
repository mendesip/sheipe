import 'package:dio/dio.dart';
import '../../domain/entities/exercise.dart';

class ExerciseRemoteDataSource {
  ExerciseRemoteDataSource({required this.dio});

  final Dio dio;

  Future<List<Exercise>> getAll({
    String? muscleGroup,
    String? category,
    String? query,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/exercises',
      queryParameters: <String, String>{
        'muscle_group': ?muscleGroup,
        'category': ?category,
        if (query != null && query.isNotEmpty) 'query': query,
      },
    );
    final data = response.data!['data'] as List<dynamic>;
    return data
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Exercise> create(Exercise exercise) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/exercises',
      data: {
        'name': exercise.name,
        'muscle_group': exercise.muscleGroup,
        'category': exercise.category,
        if (exercise.description != null) 'description': exercise.description,
      },
    );
    return Exercise.fromJson(response.data!);
  }

  Future<Exercise> update(Exercise exercise) async {
    final response = await dio.patch<Map<String, dynamic>>(
      '/api/v1/exercises/${exercise.id}',
      data: {
        'name': exercise.name,
        'muscle_group': exercise.muscleGroup,
        'category': exercise.category,
        if (exercise.description != null) 'description': exercise.description,
      },
    );
    return Exercise.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    await dio.delete<void>('/api/v1/exercises/$id');
  }
}
