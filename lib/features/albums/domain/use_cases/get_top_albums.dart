import '../entities/album_entity.dart';
import '../repositories/album_repository.dart';


class GetTopAlbums {
  final AlbumRepository _repository;

  const GetTopAlbums(this._repository);

  Future<List<AlbumEntity>> call(int limit) {
    return _repository.getTopAlbums(limit);
  }
}