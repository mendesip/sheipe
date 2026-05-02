import 'package:dio/dio.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_set.dart';

class WorkoutRemoteDataSource {
  WorkoutRemoteDataSource({required this.dio});

  final Dio dio;

  Future<List<Workout>> getAll({
    String? routineId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/api/v1/workouts',
      queryParameters: <String, String>{
        'routine_id': ?routineId,
        'start_date': ?startDate?.toIso8601String().split('T').first,
        'end_date': ?endDate?.toIso8601String().split('T').first,
      },
    );
    final data = response.data!['data'] as List<dynamic>;
    return data
        .map((w) => Workout.fromJson(w as Map<String, dynamic>))
        .toList();
  }

  Future<Workout> getById(String id) async {
    final response = await dio.get<Map<String, dynamic>>('/api/v1/workouts/$id');
    return Workout.fromJson(response.data!);
  }

  Future<Workout> start({String? routineId}) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/workouts',
      data: {'routine_id': ?routineId},
    );
    return Workout.fromJson(response.data!);
  }

  Future<Workout> update(Workout workout) async {
    final response = await dio.patch<Map<String, dynamic>>(
      '/api/v1/workouts/${workout.id}',
      data: {
        'notes': workout.notes,
        'gym_id': workout.gymId,
      },
    );
    return Workout.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    await dio.delete<void>('/api/v1/workouts/$id');
  }

  Future<Workout> finish(String id) async {
    final response = await dio.post<Map<String, dynamic>>('/api/v1/workouts/$id/finish');
    return Workout.fromJson(response.data!);
  }

  Future<WorkoutExercise> addExercise({
    required String workoutId,
    required String exerciseId,
    required int position,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/workouts/$workoutId/exercises',
      data: {'exercise_id': exerciseId, 'position': position},
    );
    return WorkoutExercise.fromJson(response.data!);
  }

  Future<void> removeExercise({required String workoutId, required String weId}) async {
    await dio.delete<void>('/api/v1/workouts/$workoutId/exercises/$weId');
  }

  Future<WorkoutSet> logSet({
    required String workoutId,
    required String weId,
    required WorkoutSet set,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/workouts/$workoutId/exercises/$weId/sets',
      data: {
        'set_number': set.setNumber,
        'weight': set.weight,
        'reps': set.reps,
        'rpe': set.rpe,
        'completed': set.completed,
      },
    );
    return WorkoutSet.fromJson(response.data!);
  }

  Future<WorkoutSet> updateSet({
    required String workoutId,
    required String weId,
    required WorkoutSet set,
  }) async {
    final response = await dio.patch<Map<String, dynamic>>(
      '/api/v1/workouts/$workoutId/exercises/$weId/sets/${set.id}',
      data: {
        'weight': set.weight,
        'reps': set.reps,
        'rpe': set.rpe,
        'completed': set.completed,
      },
    );
    return WorkoutSet.fromJson(response.data!);
  }

  Future<void> removeSet({
    required String workoutId,
    required String weId,
    required String setId,
  }) async {
    await dio.delete<void>('/api/v1/workouts/$workoutId/exercises/$weId/sets/$setId');
  }
}
