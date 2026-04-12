import '../../../../../Core/network/base_client.dart';
import '../../../../../Core/enums/http_method.dart';
import '../../models/album_model.dart';
import 'album_remote_datasource.dart';
class AlbumRemoteDatasourceImpl implements AlbumRemoteDatasource {
  final DioClient _client;

  AlbumRemoteDatasourceImpl({DioClient? client})
      : _client = client ?? DioClient();

  @override
  Future<List<AlbumModel>> getTopAlbums(int limit) async {
    final response = await _client.request(
      method: HttpMethod.get,
      path: '/us/rss/topalbums/limit=$limit/json',
    );

    final data = response.data;

    if (data != null &&
        data['feed'] != null &&
        data['feed']['entry'] != null) {
      final entries = data['feed']['entry'] as List;
      return entries
          .map((e) => AlbumModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}