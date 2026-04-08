import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:itunes/models/album_class.dart';

Future<List<Album>> fetchAlbums(int limit) async {
  final dio = Dio();
  //dio.interceptors.addAll([LogInterceptor(requestBody: true,requestHeader: true,responseBody: true,responseHeader: true)]);
  try {
    final response = await dio.get(
      'https://itunes.apple.com/us/rss/topalbums/limit=$limit/json',
    );

    if (response.statusCode == 200) {
      final data = response.data is String ? jsonDecode(response.data) :response.data;
      final entries = data['feed']['entry'] as List;
      return entries.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load any album');
    }
  }catch(e){
    throw Exception('failed to fetching in right types');
  }


}