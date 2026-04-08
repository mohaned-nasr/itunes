class Album {
  final String name;
  final String imageURl;
  final String itemCount;
  final String price;
  final String title;
  final String artist;
  final String category;
  final String ID;
  final String releaseDate;
  final String Link;


  const Album({
    required this.name,
    required this.imageURl,
    required this.artist,
    required this.category,
    required this.itemCount,
    required this.price,
    required this.title,
    required this.ID,
    required this.releaseDate,
    required this.Link,
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
        ID: json['id']['attributes']['im:id'],
        releaseDate: json['im:releaseDate']['attributes']['label'],
        Link: json['link']['attributes']['href']

    );
  }
  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      name:        map['name']         ?? '',
      imageURl:    map['image_url']    ?? '',
      artist:      map['artist']       ?? '',
      category:    map['category']     ?? '',
      itemCount:   map['item_count']   ?? '',
      price:       map['price']        ?? '',
      title:       map['title']        ?? '',
      ID:          map['album_id']     ?? '',
      releaseDate: map['release_date'] ?? '',
      Link:        map['link']         ?? '',
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'album_id':ID,
      'name' : name,
      'image_url': imageURl,
      'artist': artist,
      'category': category,
      'item_count': itemCount,
      'price': price,
      'title': title,
      'release_date': releaseDate,
      'link' : Link
    };
  }
}
