// ----------------------------
// sembast_user_database.dart
// ----------------------------

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import '../models/user.dart';

class SembastUserDatabase {
  static final _userStore = stringMapStoreFactory.store('users');
  static final _loginStore = stringMapStoreFactory.store('logins');
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    if (kIsWeb) {
      final factory = databaseFactoryWeb;
      return await factory.openDatabase('luno.db');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, 'luno.db');
      return await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    final existing = await getUser(user.email);
    if (existing != null) {
      throw Exception('Email already exists');
    }
    await _userStore.record(user.email).add(db, user.toMap());
  }

  Future<User?> getUser(String email, [String? password]) async {
    final db = await database;
    final record = await _userStore.record(email).get(db);
    if (record != null) {
      final user = User.fromMap(record);
      if (password == null || user.password == password) {
        return user;
      }
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final records = await _userStore.find(db);
    return records.map((snap) => User.fromMap(snap.value)).toList();
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    await _userStore.delete(db);
  }

  Future<void> logLogin(String email) async {
    final db = await database;
    final timestamp = DateTime.now().toString();
    await _loginStore.add(db, {'email': email, 'timestamp': timestamp});
  }

  Future<List<Map<String, dynamic>>> getLoginHistory() async {
    final db = await database;
    final records = await _loginStore.find(db);
    return records.map((snap) => snap.value).toList();
  }
}
