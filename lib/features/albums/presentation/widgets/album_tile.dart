import 'package:flutter/material.dart';
import 'package:itunes/features/albums/domain/entities/album_entity.dart';
import 'package:provider/provider.dart';
import 'package:itunes/features/albums/presentation/providers/Album_provider.dart';
import 'package:itunes/features/albums/presentation/screens/album_details_screen.dart';
import 'package:share_plus/share_plus.dart';

class AlbumTile extends StatelessWidget {
  final AlbumEntity album;

  const AlbumTile({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<AlbumProvider, bool>(
          (provider) => provider.isFavorite(album.id),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlbumDetailsScreen(album: album),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: Hero(
            tag: 'album-image-${album.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                album.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 60),
              ),
            ),
          ),
          title: Text(
            album.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(album.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                album.category,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.ios_share, color: Colors.blueGrey),
                onPressed: () {
                  final String shareMessage =
                      '🎵 Check out this album I found: \'${album.name}\' by ${album.artist}!\n'
                      'It\'s currently ${album.price} on iTunes.';
                  SharePlus.instance.share(ShareParams(text: shareMessage));
                },
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<AlbumProvider>().toggleFavorite(album);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
