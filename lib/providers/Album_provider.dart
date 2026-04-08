import 'package:flutter/material.dart';
import 'package:itunes/models/album_class.dart';
import 'package:itunes/services/api_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class AlbumProvider extends ChangeNotifier {
  List<Album> _visibleALbums = [];
  List<Album> _favouriteAlbums =[];
  Set<String> _favourites = {}; //needed to refactor
  bool _isloading = false;
  bool _isFetchingMore = false;

  int _currentLimit = 20;
  final int _maxLimit = 100 ;
  Database? _db;

  // Getters
  List<Album> get visibleAlbums => _visibleALbums;
  bool get isLoading => _isloading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _currentLimit < _maxLimit;
  List<Album> get favouriteAlbums => _favouriteAlbums;

  Future<Database> _getDb() async{
    if (_db !=null) return _db!;
    final dbPath =await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'favourites.db'),
      version: 1,
      onCreate: (db,version){
            return db.execute('''
            CREATE TABLE favourites (
            album_id TEXT PRIMARY KEY,
            name TEXT,
            image_url TEXT,
            artist TEXT,
            category TEXT,
            item_count TEXT,
            price TEXT,
            title TEXT,
            release_date TEXT,
            link TEXT
            )
            ''');
      }
    );
    return _db!;

  }

  Future<void> initializeData() async {
    _isloading = true;
    notifyListeners();

    final db = await _getDb();
    final rows = await db.query('favourites');
    _favouriteAlbums = rows.map((r) => Album.fromMap(r)).toList();
    _favourites = _favouriteAlbums.map((a) => a.ID).toSet();

    try {
      _currentLimit = 20;
      _visibleALbums =await fetchAlbums(_currentLimit);
    }catch(e){
      debugPrint("Fetch failed: $e");
    }finally{
      _isloading =false;
      notifyListeners();
    }
  }

  void loadmore() async{
    if (!hasMore || isFetchingMore) {
      return;
    }
    _isFetchingMore =true;
    notifyListeners();

    _currentLimit += 20;
    if (_currentLimit > _maxLimit) {
      _currentLimit = _maxLimit;
    }

    try {
      _visibleALbums =await fetchAlbums(_currentLimit);
    }catch(e){
      debugPrint("Load more failed: $e");
    }
    finally{
      _isFetchingMore=false;
      notifyListeners();
    }
  }

  // 4. Toggle logic
  void toggleFavorite(Album album) async {
    final db =await _getDb();
    if(_favourites.contains(album.ID)){
      _favourites.remove(album.ID);
      _favouriteAlbums.removeWhere((a) => a.ID ==album.ID);
      await db.delete('favourites', where: 'album_id = ?', whereArgs: [album.ID]);
    }else{
      _favourites.add(album.ID);
      _favouriteAlbums.add(album);
      await db.insert('favourites', album.toMap(),conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    notifyListeners();
  }
  bool isFavorite(String id) => _favourites.contains(id);

}