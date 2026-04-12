import '../entities/album_entity.dart';

abstract class AlbumRepository{
  Future<List<AlbumEntity>> getTopAlbums(int limit);
  Future<List<AlbumEntity>> getFavourites();
  Future<void> addFavourite(AlbumEntity album);
  Future<void> removeFavourite(String id);
}