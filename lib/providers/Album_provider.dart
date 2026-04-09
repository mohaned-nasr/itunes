import 'package:flutter/material.dart';
import 'package:itunes/models/album_class.dart';
import 'package:itunes/services/api_service.dart';
import 'package:itunes/services/database_service.dart';
import '../network/network_exception.dart';




class AlbumProvider extends ChangeNotifier {
  final DatabaseService _dbService;

  AlbumProvider({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService();
  List<Album> _visibleALbums = [];
  List<Album> _favouriteAlbums =[];
  Set<String> _favourites = {};
  bool _isloading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;

  int _currentLimit = 20;
  final int _maxLimit = 100 ;

  // Getters
  List<Album> get visibleAlbums => _visibleALbums;
  bool get isLoading => _isloading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _currentLimit < _maxLimit;
  List<Album> get favouriteAlbums => _favouriteAlbums;
  String? get errorMessage => _errorMessage;


  Future<void> initializeData() async {
    _isloading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rows = await _dbService.getAllFavourites();
      _favouriteAlbums = rows.map((r) => Album.fromMap(r)).toList();
      _favourites = _favouriteAlbums.map((a) => a.ID).toSet();
    } catch (e) {
      debugPrint("Failed to load favourites from DB: $e");
    }

    try {
      _currentLimit = 20;
      _visibleALbums = await fetchAlbums(_currentLimit);
    } on NetworkException catch (e){
      _errorMessage = e.message;
      debugPrint("Network Error: ${e.message}");
    } catch (e) {
      _errorMessage = 'Could not load albums. Check your connection.';
      debugPrint("Fetch failed: $e");
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }


  Future<void> loadmore() async{
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
    }on NetworkException catch (e) {
      debugPrint("Load more network error: ${e.message}");
    } catch(e){
      debugPrint("Load more failed: $e");
    }
    finally{
      _isFetchingMore=false;
      notifyListeners();
    }
  }

Future<void> toggleFavorite(Album album) async {
  final wasAlreadyFav = _favourites.contains(album.ID);

  if (wasAlreadyFav) {
    _favourites.remove(album.ID);
    _favouriteAlbums.removeWhere((a) => a.ID == album.ID);
  } else {
    _favourites.add(album.ID);
    _favouriteAlbums.add(album);
  }
  notifyListeners();


  try {
    if (wasAlreadyFav) {
      await _dbService.deleteFavourite(album.ID);
    } else {
      await _dbService.insertFavourite(album);
    }
  } catch (e) {
    debugPrint("DB toggle failed, rolling back: $e");
    // Rollback the optimistic update
    if (wasAlreadyFav) {
      _favourites.add(album.ID);
      _favouriteAlbums.add(album);
    } else {
      _favourites.remove(album.ID);
      _favouriteAlbums.removeWhere((a) => a.ID == album.ID);
    }
    notifyListeners();
  }
}
  bool isFavorite(String id) => _favourites.contains(id);

}