import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';

import 'database_helper.dart';

class CategoryTable {
  final tableName = 'category_table';
  final id = 'category_id';
  final order = 'category_order';
  final color = 'category_color';
  final name = 'category_name';
  final type = 'transaction_type';

  void onCreate(Database db, int version) {
    db.execute('CREATE TABLE $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$order INTEGER NOT NULL,'
        '$color INTEGER NOT NULL,'
        '$name TEXT NOT NULL UNIQUE,'
        '$type INTEGER NOT NULL)');
  }

  Future<int> insert(Category category) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String sql = 'INSERT INTO $tableName($order, $color, $name, $type)'
        ' VALUES((SELECT (IFNULL(MAX($order), 0)+1) $order FROM $tableName),'
        ' ${category.color.value},'
        ' "${category.name}",'
        ' ${category.transactionType.value})';

    // Insert the Category into the correct table.
    return db.rawInsert(sql);
  }

  Future<List<Category>> getAll(TransactionType transactionType) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: transactionType == null ? null : '$type = ?',
      whereArgs: transactionType == null ? null : [transactionType.value],
      orderBy: '$order ASC',
    );

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> delete(int categoryId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    return db.delete(tableName, where: id + '=?', whereArgs: [categoryId]);
  }

  Future<int> update(Category category) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Update the correct category.
    return db.update(
      tableName,
      category.toMap(),
      // Ensure that the category has a matching id.
      where: "$id=?",
      // Pass the category's id as a whereArg to prevent SQL injection.
      whereArgs: [category.id],
    );
  }

  Future<int> updateColumn({
    @required List<int> ids,
    @required String column,
    @required List<dynamic> values,
  }) async {
    if (ids.length != values.length) {
      throw AssertionError('ids\'s length and values\'s length'
          ' must be equal!');
    }

    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String sql = 'UPDATE $tableName'
        ' SET $column=(CASE ${this.id}';

    String whereIn = '';
    for (int i = 0; i < ids.length; i++) {
      sql += ' WHEN ${ids[i]} THEN ${values[i]}';

      whereIn += ids[i].toString();
      if (i + 1 < ids.length) {
        whereIn += ',';
      }
    }

    sql += ' ELSE $column'
        ' END)'
        ' WHERE ${this.id} IN($whereIn)';

    return db.rawUpdate(sql);
  }
}
