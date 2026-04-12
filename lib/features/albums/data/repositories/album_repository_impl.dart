import '../../domain/entities/album_entity.dart';
import '../../domain/repositories/album_repository.dart';
import '../datasources/remote/album_remote_datasource.dart';
import '../datasources/local/album_local_datasource.dart';
import '../models/album_model.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumRemoteDatasource _remoteDatasource;
  final AlbumLocalDatasource _localDatasource;

  AlbumRepositoryImpl({
    required AlbumRemoteDatasource remoteDatasource,
    required AlbumLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Future<List<AlbumEntity>> getTopAlbums(int limit) async {
    return await _remoteDatasource.getTopAlbums(limit);
  }

  @override
  Future<List<AlbumEntity>> getFavourites() async {
    return await _localDatasource.getAllFavourites();
  }

  @override
  Future<void> addFavourite(AlbumEntity album) async {
    final model = AlbumModel.fromEntity(album);
    await _localDatasource.insertFavourite(model);
  }

  @override
  Future<void> removeFavourite(String id) async {
    await _localDatasource.deleteFavourite(id);
  }
}