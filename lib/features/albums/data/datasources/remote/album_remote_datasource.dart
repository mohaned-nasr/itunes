import '../../models/album_model.dart';

abstract class AlbumRemoteDatasource {
  Future<List<AlbumModel>> getTopAlbums(int limit);
}
