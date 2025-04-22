import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class CartDatabase {
  static final CartDatabase _singleton = CartDatabase._internal();
  static CartDatabase get instance => _singleton;

  late Database _db;
  final _store = intMapStoreFactory.store('cart');

  CartDatabase._internal();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'cart.db');
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    await _store.add(_db, item);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final records = await _store.find(_db);
    return records.map((e) => e.value).toList();
  }

  Future<List<int>> getRawKeys() async {
    final records = await _store.find(_db);
    return records.map((e) => e.key).toList();
  }

  Future<void> removeItem(int key) async {
    await _store.record(key).delete(_db);
  }

  Future<void> clearCart() async {
    await _store.delete(_db);
  }
}
