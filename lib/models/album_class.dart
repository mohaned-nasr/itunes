class Album {
  final String name;
  final String imageURl;
  final String itemCount;
  final String price;
  final String title;
  final String artist;
  final String category;
  final String ID;


  const Album({
    required this.name,
    required this.imageURl,
    required this.artist,
    required this.category,
    required this.itemCount,
    required this.price,
    required this.title,
    required this.ID
    });

  factory Album.fromJson(Map<String, dynamic> json) {
    final List imageList = json['im:image'] as List;
    return Album(
        name: json['im:name']['label'],
        imageURl: imageList.last['label'],
        artist: json['im:artist']['label'],
        category: json['category']['attributes']['term'],
        itemCount: json['im:itemCount']['label'],
        price: json['im:price']['label'],
        title: json['title']['label'],
        ID: json['id']['attributes']['im:id']
    );

  }
}
