class AlbumEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String artist;
  final String category;
  final String itemCount;
  final String price;
  final String title;
  final String releaseDate;
  final String link;

  const AlbumEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artist,
    required this.category,
    required this.itemCount,
    required this.price,
    required this.title,
    required this.releaseDate,
    required this.link,
  });
}