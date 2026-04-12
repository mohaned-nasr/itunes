import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itunes/features/albums/data/repositories/album_repository_impl.dart';
import 'package:itunes/features/albums/domain/use_cases/get_top_albums.dart';
import 'package:itunes/features/albums/domain/use_cases/get_favourites.dart';
import 'package:itunes/features/albums/domain/use_cases/toggle_favourite.dart';
import 'package:itunes/features/albums/presentation/providers/Album_provider.dart';
import 'package:itunes/features/albums/presentation/screens/home_screen.dart';
import 'features/albums/data/datasources/local/album_local_datasource_impl.dart';
import 'features/albums/data/datasources/remote/album_remote_datasource_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final remoteDatasource = AlbumRemoteDatasourceImpl();
  final localDatasource = AlbumLocalDatasourceImpl();

  final repository = AlbumRepositoryImpl(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
  );

  final getTopAlbums = GetTopAlbums(repository);
  final getFavourites = GetFavourites(repository);
  final toggleFavourite = ToggleFavourite(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AlbumProvider(
        getTopAlbums: getTopAlbums,
        getFavourites: getFavourites,
        toggleFavourite: toggleFavourite,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
