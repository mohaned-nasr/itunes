import 'package:itunes/models/album_class.dart';
import '../network/base_client.dart';
import '../enums/http_method.dart';

Future<List<Album>> fetchAlbums(int limit) async {
    final response = await DioClient().request(
        method: HttpMethod.get, // <-- Define the method here
        path: '/us/rss/topalbums/limit=$limit/json',
    );
    final data = response.data;
    final entries = data['feed']['entry'] as List;
    return entries.map((e) => Album.fromJson(e as Map<String, dynamic>)).toList();

}