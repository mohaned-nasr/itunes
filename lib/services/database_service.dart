import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:itunes/models/album_class.dart';

class DatabaseService {
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

  Future<List<Map<String, dynamic>>> getAllFavourites() async {
    final db = await _getDb();
    return db.query('favourites');
  }

  Future<void> insertFavourite(Album album) async {
    final db = await _getDb();
    await db.insert(
      'favourites',
      album.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFavourite(String albumId) async {
    final db = await _getDb();
    await db.delete(
      'favourites',
      where: 'album_id = ?',
      whereArgs: [albumId],
    );
  }
}
