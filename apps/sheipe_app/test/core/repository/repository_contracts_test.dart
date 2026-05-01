import 'package:flutter_test/flutter_test.dart';
import 'package:sheipe_app/core/repository/local_data_source.dart';
import 'package:sheipe_app/core/repository/remote_data_source.dart';
import 'package:sheipe_app/core/repository/base_repository.dart';

class _TestEntity {
  const _TestEntity(this.id);
  final String id;
}

class _StubLocalDataSource implements LocalDataSource<_TestEntity> {
  @override
  Future<List<_TestEntity>> getAll() async => [];
  @override
  Future<_TestEntity?> getById(String id) async => null;
  @override
  Future<void> save(_TestEntity entity) async {}
  @override
  Future<void> delete(String id) async {}
}

class _StubRemoteDataSource implements RemoteDataSource<_TestEntity> {
  @override
  Future<List<_TestEntity>> fetchAll() async => [];
  @override
  Future<_TestEntity> fetchById(String id) async => _TestEntity(id);
  @override
  Future<_TestEntity> create(_TestEntity entity) async => entity;
  @override
  Future<_TestEntity> update(_TestEntity entity) async => entity;
  @override
  Future<void> delete(String id) async {}
}

class _StubRepository extends BaseRepository<_TestEntity> {
  _StubRepository()
      : super(
          local: _StubLocalDataSource(),
          remote: _StubRemoteDataSource(),
        );
}

void main() {
  group('LocalDataSource contract', () {
    test('concrete stub satisfies all method signatures', () async {
      final source = _StubLocalDataSource();
      await expectLater(source.getAll(), completes);
      await expectLater(source.getById('id'), completes);
      await expectLater(source.save(const _TestEntity('id')), completes);
      await expectLater(source.delete('id'), completes);
    });
  });

  group('RemoteDataSource contract', () {
    test('concrete stub satisfies all method signatures', () async {
      final source = _StubRemoteDataSource();
      await expectLater(source.fetchAll(), completes);
      await expectLater(source.fetchById('id'), completes);
      await expectLater(source.create(const _TestEntity('id')), completes);
      await expectLater(source.update(const _TestEntity('id')), completes);
      await expectLater(source.delete('id'), completes);
    });
  });

  group('BaseRepository contract', () {
    test('exposes local and remote data sources', () {
      final repo = _StubRepository();
      expect(repo.local, isA<LocalDataSource<_TestEntity>>());
      expect(repo.remote, isA<RemoteDataSource<_TestEntity>>());
    });
  });
}
