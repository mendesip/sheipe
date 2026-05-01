import 'local_data_source.dart';
import 'remote_data_source.dart';

abstract class BaseRepository<T> {
  BaseRepository({required this.local, required this.remote});

  final LocalDataSource<T> local;
  final RemoteDataSource<T> remote;
}
