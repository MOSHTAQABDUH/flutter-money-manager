import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/utils/color_util.dart';

class Category {
  int id;
  int order;
  Color color;
  String name;
  TransactionType transactionType;

  Category({this.id, this.order, this.color, this.name, this.transactionType});

  Category.fromMap(Map<String, dynamic> map) {
    id = map[CategoryTable().id];
    order = map[CategoryTable().order];
    color = valueToColor(map[CategoryTable().color]);
    name = map[CategoryTable().name];
    transactionType = TransactionType.valueOf(map[CategoryTable().type]);
  }

  Map<String, dynamic> toMap() {
    return {
      CategoryTable().id: id,
      CategoryTable().order: order,
      CategoryTable().color: color.value,
      CategoryTable().name: name,
      CategoryTable().type: transactionType.value,
    };
  }

  @override
  String toString() {
    return 'Category{\n'
        'id : $id\n'
        'order : $order\n'
        'color : ${color.value}\n'
        'name : $name\n'
        'transactionType : ${transactionType.name}\n'
        '}';
  }
}
