import 'package:dio/dio.dart';
import '../../domain/entities/routine.dart';
import '../../domain/entities/routine_exercise.dart';
import '../../domain/entities/routine_set.dart';

class RoutineRemoteDataSource {
  RoutineRemoteDataSource({required this.dio});

  final Dio dio;

  Future<List<Routine>> getAll() async {
    final response = await dio.get<Map<String, dynamic>>('/api/v1/routines');
    final data = response.data!['data'] as List<dynamic>;
    return data
        .map((r) => Routine.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<Routine> getById(String id) async {
    final response = await dio.get<Map<String, dynamic>>('/api/v1/routines/$id');
    return Routine.fromJson(response.data!);
  }

  Future<Routine> create(Routine routine) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/routines',
      data: {
        'name': routine.name,
        'description': routine.description,
        'is_template': routine.isTemplate,
      },
    );
    return Routine.fromJson(response.data!);
  }

  Future<Routine> update(Routine routine) async {
    final response = await dio.patch<Map<String, dynamic>>(
      '/api/v1/routines/${routine.id}',
      data: {
        'name': routine.name,
        'description': routine.description,
        'is_template': routine.isTemplate,
      },
    );
    return Routine.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    await dio.delete<void>('/api/v1/routines/$id');
  }

  // Nested resource calls

  Future<RoutineExercise> addExercise({
    required String routineId,
    required String exerciseId,
    required int position,
    String? notes,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/routines/$routineId/exercises',
      data: {
        'exercise_id': exerciseId,
        'position': position,
        'notes': ?notes,
      },
    );
    return RoutineExercise.fromJson(response.data!);
  }

  Future<void> removeExercise({required String routineId, required String reId}) async {
    await dio.delete<void>('/api/v1/routines/$routineId/exercises/$reId');
  }

  Future<RoutineSet> addSet({
    required String routineId,
    required String reId,
    required RoutineSet set,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/routines/$routineId/exercises/$reId/sets',
      data: {
        'set_number': set.setNumber,
        'weight': set.weight,
        'reps': set.reps,
        'rest_seconds': set.restSeconds,
        'set_type': set.setType,
      },
    );
    return RoutineSet.fromJson(response.data!);
  }

  Future<void> removeSet({
    required String routineId,
    required String reId,
    required String setId,
  }) async {
    await dio.delete<void>('/api/v1/routines/$routineId/exercises/$reId/sets/$setId');
  }
}
