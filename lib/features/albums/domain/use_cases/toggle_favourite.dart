import '../entities/album_entity.dart';
import '../repositories/album_repository.dart';

class ToggleFavourite {
  final AlbumRepository _repository;

  const ToggleFavourite(this._repository);
  Future<bool> call({
    required AlbumEntity album,
    required bool currentlyFavourited,
  }) async {
    if (currentlyFavourited) {
      await _repository.removeFavourite(album.id);
      return false;
    } else {
      await _repository.addFavourite(album);
      return true;
    }
  }
}