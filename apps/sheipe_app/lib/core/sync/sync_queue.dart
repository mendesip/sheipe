import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../storage/app_database.dart';

/// Operation kind for an offline-first mutation.
enum SyncOp { create, update, delete }

/// Wraps writes to [SyncOperationsTable] so repositories don't need to know
/// about Drift internals.
class SyncQueue {
  SyncQueue({required this.db, Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase db;
  final Uuid _uuid;

  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required SyncOp operation,
    Map<String, dynamic>? payload,
  }) async {
    await db.into(db.syncOperationsTable).insert(
          SyncOperationsTableCompanion.insert(
            id: _uuid.v4(),
            entityType: entityType,
            entityId: entityId,
            operation: operation.name,
            payload: Value(payload == null ? null : jsonEncode(payload)),
            createdAt: DateTime.now(),
          ),
        );
  }

  Stream<List<SyncOperationsTableData>> watchPending() {
    final select = db.select(db.syncOperationsTable)
      ..where((t) => t.syncedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);
    return select.watch();
  }

  Future<List<SyncOperationsTableData>> pending() {
    final select = db.select(db.syncOperationsTable)
      ..where((t) => t.syncedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);
    return select.get();
  }

  Future<void> markSynced(String id) async {
    await (db.update(db.syncOperationsTable)..where((t) => t.id.equals(id)))
        .write(SyncOperationsTableCompanion(syncedAt: Value(DateTime.now())));
  }

  Future<void> markFailed(String id, String error) async {
    final row = await (db.select(db.syncOperationsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await (db.update(db.syncOperationsTable)..where((t) => t.id.equals(id))).write(
      SyncOperationsTableCompanion(
        attemptCount: Value(row.attemptCount + 1),
        lastError: Value(error),
      ),
    );
  }
}
