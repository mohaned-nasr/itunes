import '../entities/album_entity.dart';
import '../repositories/album_repository.dart';

class GetFavourites {
  final AlbumRepository _repository;

  const GetFavourites(this._repository);

  Future<List<AlbumEntity>> call() {
    return _repository.getFavourites();
  }
}


