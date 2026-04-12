import '../../domain/entities/album_entity.dart';

class AlbumModel extends AlbumEntity {
  const AlbumModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.artist,
    required super.category,
    required super.itemCount,
    required super.price,
    required super.title,
    required super.releaseDate,
    required super.link,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    final List imageList = json['im:image'] as List;
    return AlbumModel(
      id: json['id']['attributes']['im:id'],
      name: json['im:name']['label'],
      imageUrl: imageList.last['label'],
      artist: json['im:artist']['label'],
      category: json['category']['attributes']['term'],
      itemCount: json['im:itemCount']['label'],
      price: json['im:price']['label'],
      title: json['title']['label'],
      releaseDate: json['im:releaseDate']['attributes']['label'],
      link: json['link']['attributes']['href'],
    );
  }

  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      id: map['album_id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['image_url'] ?? '',
      artist: map['artist'] ?? '',
      category: map['category'] ?? '',
      itemCount: map['item_count'] ?? '',
      price: map['price'] ?? '',
      title: map['title'] ?? '',
      releaseDate: map['release_date'] ?? '',
      link: map['link'] ?? '',
    );
  }

  factory AlbumModel.fromEntity(AlbumEntity entity) {
    return AlbumModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      artist: entity.artist,
      category: entity.category,
      itemCount: entity.itemCount,
      price: entity.price,
      title: entity.title,
      releaseDate: entity.releaseDate,
      link: entity.link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'album_id': id,
      'name': name,
      'image_url': imageUrl,
      'artist': artist,
      'category': category,
      'item_count': itemCount,
      'price': price,
      'title': title,
      'release_date': releaseDate,
      'link': link,
    };
  }
}