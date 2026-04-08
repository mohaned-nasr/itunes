import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/album_provider.dart';
import '../widgets/album_tile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<AlbumProvider>().favouriteAlbums;


    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favs.isEmpty
          ? const Center(
        child: Text(
          'No favorites yet!\nTap the heart on an album to add it.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favs.length,
        itemBuilder: (context, index) => AlbumTile(album: favs[index]),
      ),
    );
  }
}