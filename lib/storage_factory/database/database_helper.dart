import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'category_table.dart';
import 'transaction_table.dart';

class DatabaseHelper {
  final String _databaseName = 'money_manager.db';
  final int _databaseVersion = 1;

  static Database _db;

  Future<Database> get db async {
    // Get a singleton database
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    // This will delete old/previous database when app is opened
    // Delete the database
    // await deleteDatabase(path);

    // Open the database
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    CategoryTable().onCreate(db, version);
    TransactionTable().onCreate(db, version);

    // Create other tables ...
  }
}
