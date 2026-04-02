import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:itunes/models/album_class.dart';

Future<List<Album>> fetchAlbums() async {
  final dio = Dio();
  dio.interceptors.addAll([LogInterceptor(requestBody: true,requestHeader: true,responseBody: true,responseHeader: true)]);
  try {
    final response = await dio.get(
      'https://itunes.apple.com/us/rss/topalbums/limit=100/json',
    );

    if (response.statusCode == 200) {
      final entries = response.data['feed']['entry'] as List;
      log(entries[0].toString(),name: '/////////////////////////////moahend');
      return entries.map((e) => Album.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load any album');
    }
  }catch(e){
    throw Exception('failed to fetching in right types');
  }
}