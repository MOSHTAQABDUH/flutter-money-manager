import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';

import 'category.dart';

class MyTransaction {
  int id;
  DateTime date;
  double amount;
  String description;
  Category category;
  DateTime lastModifiedDate;
  bool deleted;

  MyTransaction({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.category,
    this.lastModifiedDate,
    this.deleted,
  });

  MyTransaction.fromMap(Map<String, dynamic> map) {
    id = map[TransactionTable().id];
    date = DateTime.parse(map[TransactionTable().date]);
    amount = map[TransactionTable().amount];
    description = map[TransactionTable().description];
    category = Category.fromMap(map);
    String temp = map[TransactionTable().lastModifiedDate];
    lastModifiedDate = temp == null ? null : DateTime.parse(temp);
    deleted = map[TransactionTable().deleted] == 1;
  }

  Map<String, dynamic> toMap() {
    return {
      TransactionTable().id: id,
      TransactionTable().date: convertToISO8601DateFormat(date),
      TransactionTable().amount: amount,
      TransactionTable().description: description,
      TransactionTable().category: category.id,
      TransactionTable().lastModifiedDate:
          convertToISO8601DateFormat(lastModifiedDate),
      TransactionTable().deleted: deleted ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'Transaction{\n'
        'id : $id\n'
        'date : $date\n'
        'amount : $amount\n'
        'description : $description\n'
        'category : $category\n'
        'lastModifiedDate : $lastModifiedDate\n'
        'deleted : $deleted\n'
        '}';
  }
}
