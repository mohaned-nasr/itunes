import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itunes/models/album_class.dart';
import 'package:itunes/providers/album_provider.dart';
import 'package:share_plus/share_plus.dart';


class AlbumTile extends StatelessWidget {
  final Album album;

  const AlbumTile({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<AlbumProvider, bool>(
          (provider) => provider.isFavorite(album.ID),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            album.imageURl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 60),
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
        trailing:
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.ios_share,color: Colors.blueGrey),
              onPressed: (){

                final String shareMessage =
                    "🎵 Check out this album I found: '${album.name}' by ${album.artist}!\n"
                    "It's currently ${album.price} on iTunes.";
                SharePlus.instance.share(ShareParams(text: shareMessage));
              },
            ),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () {
                context.read<AlbumProvider>().toggleFavorite(album.ID);
              },
            )
          ],
        ),


      ),
    );
  }
}