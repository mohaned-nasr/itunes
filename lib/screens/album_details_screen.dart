import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/album_class.dart';
import '../providers/album_provider.dart';
import '../widgets/StatChip.dart';
import '../widgets/InfoRow.dart';

class AlbumDetailsScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailsScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<AlbumProvider, bool>(
          (p) => p.isFavorite(album.ID),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsing hero app bar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                tooltip: 'Share',
                icon: const Icon(Icons.ios_share, color: Colors.white),
                onPressed: () {
                  final msg =
                      '🎵 Check out "${album.name}" by ${album.artist}!\n'
                      'It\'s currently ${album.price} on iTunes.';
                  SharePlus.instance.share(ShareParams(text: msg));
                },
              ),
              IconButton(
                tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.white,
                ),
                onPressed: () =>
                    context.read<AlbumProvider>().toggleFavorite(album),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Album art via Hero
                  Hero(
                    tag: 'album-image-${album.ID}',
                    child: Image.network(
                      album.imageURl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.album,
                            size: 80, color: Colors.white30),
                      ),
                    ),
                  ),
                  // Gradient fade at the bottom so title is readable
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.55, 1.0],
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                  ),
                  // Album name + artist overlaid at bottom of the art
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black54),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          album.artist,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body content ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat chips row
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      StatChip(
                        icon: Icons.music_note,
                        label: '${album.itemCount} tracks',
                        color: Colors.deepPurple,
                      ),
                      StatChip(
                        icon: Icons.sell_outlined,
                        label: album.price,
                        color: Colors.teal,
                      ),
                      StatChip(
                        icon: Icons.category_outlined,
                        label: album.category,
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Info rows
                  InfoRow(label: 'Artist', value: album.artist),
                  if (album.releaseDate.isNotEmpty)
                    InfoRow(label: 'Released', value: album.releaseDate),
                  InfoRow(label: 'Genre', value: album.category),
                  InfoRow(label: 'Tracks', value: album.itemCount),
                  InfoRow(label: 'Price', value: album.price),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Open on iTunes button
                  if (album.Link.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text(
                          'Open in iTunes / Apple Music',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(album.Link);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Favourite toggle button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                        isFav ? Colors.redAccent : Colors.grey[700],
                        side: BorderSide(
                          color: isFav ? Colors.redAccent : Colors.grey,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                      ),
                      label: Text(
                        isFav ? 'Remove from Favourites' : 'Add to Favourites',
                        style: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () =>
                          context.read<AlbumProvider>().toggleFavorite(album),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





