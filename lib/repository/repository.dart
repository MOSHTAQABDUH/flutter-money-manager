import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';

class Repository {
  final TransactionTable _transactionTable = TransactionTable();
  final CategoryTable _categoryTable = CategoryTable();

  Future<double> getTotalBalance() => _transactionTable.getTotalBalance();

  Future<int> moveToTrash(int id) => _transactionTable.updateColumn(
        id: id,
        column: _transactionTable.deleted,
        value: 1,
      );

  Future<int> restoreTransaction(int id) => _transactionTable.updateColumn(
        id: id,
        column: _transactionTable.deleted,
        value: 0,
      );

  Future<int> deleteOldTransaction(int noticeDayDuration) =>
      _transactionTable.deleteOldTransaction(noticeDayDuration);

  Future<List<Category>> fetchCategories(TransactionType transactionType) =>
      _categoryTable.getAll(transactionType);

  Future<int> deleteBackupTransactions() =>
      _transactionTable.deleteBackupTransactions();

  Future<Map<TransactionType, double>> getTotalExpenseAndIncome() =>
      _transactionTable.getTotalExpenseAndIncome();

  Future<List<MyTransaction>> getTransactions({
    TransactionFilterType transactionFilterType,
    bool deleted,
  }) =>
      _transactionTable.getAll(
        transactionFilterType: transactionFilterType,
        deleted: false,
      );
}
