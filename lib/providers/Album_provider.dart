import 'package:flutter/material.dart';
import 'package:itunes/models/album_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itunes/services/api_service.dart';


class AlbumProvider extends ChangeNotifier {
  List<Album> _visibleALbums = [];
  Set<String> _favourites = {};
  bool _isloading = false;
  bool _isFetchingMore = false;

  int _currentLimit = 20;
  final int _maxLimit = 100 ;

  // Getters
  List<Album> get visibleAlbums => _visibleALbums;
  bool get isLoading => _isloading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _currentLimit < _maxLimit;

  //fetching favourites
  List <Album> get favoriteAlbums => _visibleALbums.where((album) => _favourites.contains(album.ID)).toList();

  Future<void> initializeData() async {
    _isloading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedFavs = prefs.getStringList('fav_ids') ?? [];
    _favourites = savedFavs.toSet();

    try {
      _currentLimit =20;
      _visibleALbums =await fetchAlbums(_currentLimit);
    } catch (e) {
      debugPrint("Fetch failed: $e");
    } finally {
      _isloading = false;
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
  void toggleFavorite(String albumId) async {
    if (_favourites.contains(albumId)) {
      _favourites.remove(albumId);
    } else {
      _favourites.add(albumId);
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('fav_ids', _favourites.toList());
  }
  bool isFavorite(String id) => _favourites.contains(id);

}