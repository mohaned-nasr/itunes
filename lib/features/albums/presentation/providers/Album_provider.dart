import 'package:flutter/material.dart';
import 'package:itunes/features/albums/domain/entities/album_entity.dart';
import '../../../../Core/network/network_exception.dart';
import '../../domain/use_cases/get_favourites.dart';
import '../../domain/use_cases/get_top_albums.dart';
import '../../domain/use_cases/toggle_favourite.dart';




class AlbumProvider extends ChangeNotifier {
  final GetTopAlbums _getTopAlbums;
  final GetFavourites _getFavourites;
  final ToggleFavourite _toggleFavourite;

  AlbumProvider({
    required GetTopAlbums getTopAlbums,
    required GetFavourites getFavourites,
    required ToggleFavourite toggleFavourite,

}) : _getTopAlbums =getTopAlbums,
        _getFavourites = getFavourites,
        _toggleFavourite = toggleFavourite;

  List<AlbumEntity> _visibleALbums = [];
  List<AlbumEntity> _favouriteAlbums =[];
  Set<String> _favouriteIds = {};
  bool _isloading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;

  int _currentLimit = 20;
  final int _maxLimit = 100 ;

  // Getters
  List<AlbumEntity> get visibleAlbums => _visibleALbums;
  bool get isLoading => _isloading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _currentLimit < _maxLimit;
  List<AlbumEntity> get favouriteAlbums => _favouriteAlbums;
  String? get errorMessage => _errorMessage;


  Future<void> initializeData() async {
    _isloading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favouriteAlbums = await _getFavourites();
      _favouriteIds = _favouriteAlbums.map((a) => a.id).toSet();
    } catch (e) {
      debugPrint("Failed to load favourites from DB: $e");
    }

    try {
      _currentLimit = 20;
      _visibleALbums = await _getTopAlbums(_currentLimit);
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
      _visibleALbums =await _getTopAlbums(_currentLimit);
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

Future<void> toggleFavorite(AlbumEntity album) async {
  final wasAlreadyFav = _favouriteIds.contains(album.id);

  if (wasAlreadyFav) {
    _favouriteIds.remove(album.id);
    _favouriteAlbums.removeWhere((a) => a.id == album.id);
  } else {
    _favouriteIds.add(album.id);
    _favouriteAlbums.add(album);
  }
  notifyListeners();


  try {
    await _toggleFavourite(
      album: album,
      currentlyFavourited: wasAlreadyFav,
    );
  } catch (e) {
    debugPrint("DB toggle failed, rolling back: $e");
    if (wasAlreadyFav) {
      _favouriteIds.add(album.id);
      _favouriteAlbums.add(album);
    } else {
      _favouriteIds.remove(album.id);
      _favouriteAlbums.removeWhere((a) => a.id == album.id);
    }
    notifyListeners();
  }
}
  bool isFavorite(String id) => _favouriteIds.contains(id);

}