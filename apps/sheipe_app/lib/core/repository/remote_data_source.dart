abstract class RemoteDataSource<T> {
  Future<List<T>> fetchAll();
  Future<T> fetchById(String id);
  Future<T> create(T entity);
  Future<T> update(T entity);
  Future<void> delete(String id);
}
