import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import '../models/product.dart';

class FavoriteDatabase {
  static final FavoriteDatabase instance = FavoriteDatabase._internal();

  FavoriteDatabase._internal();

  static const String _dbName = 'favorites.db';
  static const String _storeName = 'favorites_store';

  late final Database _db;
  final _store = stringMapStoreFactory.store(_storeName);

  Future<void> init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dbPath = join(dir.path, _dbName);
    _db = await databaseFactoryIo.openDatabase(dbPath);
    print("Favorites database initialized at: $dbPath");
  }

  Future<void> addFavorite(Product product) async {
    await _store.record(product.name).put(_db, product.toJson());
    print("Added to favorites: ${product.name}");
  }

  Future<void> removeFavorite(String name) async {
    await _store.record(name).delete(_db);
    print("Removed from favorites: $name");
  }

  Future<List<Product>> getFavorites() async {
    final List<RecordSnapshot<String, Map<String, dynamic>>> records = await _store.find(_db);
    return records.map((snap) => Product.fromJson(snap.value)).toList();
  }

  Future<bool> isFavorite(String name) async {
    final data = await _store.record(name).get(_db);
    return data != null;
  }

  Future<void> clearFavorites() async {
    await _store.delete(_db);
    print("All favorites cleared.");
  }
}
