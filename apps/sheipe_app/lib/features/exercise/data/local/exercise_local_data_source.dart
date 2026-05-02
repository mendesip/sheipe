import 'package:drift/drift.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/exercise.dart';

class ExerciseLocalDataSource {
  ExerciseLocalDataSource({required this.db});

  final AppDatabase db;

  Stream<List<Exercise>> watchAll({
    String? muscleGroup,
    String? category,
    String? query,
  }) {
    final select = db.select(db.exercisesTable);
    select.orderBy([(t) => OrderingTerm(expression: t.name)]);
    if (muscleGroup != null) {
      select.where((t) => t.muscleGroup.equals(muscleGroup));
    }
    if (category != null) {
      select.where((t) => t.category.equals(category));
    }
    if (query != null && query.isNotEmpty) {
      select.where((t) => t.name.lower().like('%${query.toLowerCase()}%'));
    }
    return select.watch().map((rows) => rows.map(_fromRow).toList());
  }

  Future<Exercise?> findById(String id) async {
    final row = await (db.select(db.exercisesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<void> upsert(Exercise exercise) async {
    await db.into(db.exercisesTable).insertOnConflictUpdate(
          ExercisesTableCompanion.insert(
            id: exercise.id,
            name: exercise.name,
            description: Value(exercise.description),
            muscleGroup: exercise.muscleGroup,
            category: exercise.category,
            isSystem: Value(exercise.isSystem),
            creatorId: Value(exercise.creatorId),
            createdAt: Value(exercise.createdAt),
            updatedAt: Value(exercise.updatedAt),
          ),
        );
  }

  Future<void> upsertAll(List<Exercise> exercises) async {
    await db.batch((batch) {
      for (final e in exercises) {
        batch.insert(
          db.exercisesTable,
          ExercisesTableCompanion.insert(
            id: e.id,
            name: e.name,
            description: Value(e.description),
            muscleGroup: e.muscleGroup,
            category: e.category,
            isSystem: Value(e.isSystem),
            creatorId: Value(e.creatorId),
            createdAt: Value(e.createdAt),
            updatedAt: Value(e.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> deleteById(String id) async {
    await (db.delete(db.exercisesTable)..where((t) => t.id.equals(id))).go();
  }

  Exercise _fromRow(ExercisesTableData row) => Exercise(
        id: row.id,
        name: row.name,
        muscleGroup: row.muscleGroup,
        category: row.category,
        description: row.description,
        isSystem: row.isSystem,
        creatorId: row.creatorId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}
