import '../../models/album_model.dart';

abstract class AlbumLocalDatasource {
  Future<List<AlbumModel>> getAllFavourites();
  Future<void> insertFavourite(AlbumModel album);
  Future<void> deleteFavourite(String albumId);
}