import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/album_model.dart';
import 'album_local_datasource.dart';

class AlbumLocalDatasourceImpl implements AlbumLocalDatasource {
  Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'favourites.db'),
      version: 1,
      onCreate: (db, version) {
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
      },
    );
    return _db!;
  }

  @override
  Future<List<AlbumModel>> getAllFavourites() async {
    final db = await _getDb();
    final rows = await db.query('favourites');
    return rows.map((row) => AlbumModel.fromMap(row)).toList();
  }

  @override
  Future<void> insertFavourite(AlbumModel album) async {
    final db = await _getDb();
    await db.insert(
      'favourites',
      album.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<void> deleteFavourite(String albumId) async {
    final db = await _getDb();
    await db.delete(
      'favourites',
      where: 'album_id = ?',
      whereArgs: [albumId],
    );
  }
}