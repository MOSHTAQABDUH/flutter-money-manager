import 'package:flutter/material.dart';
import 'package:flutter_money_manager/routes/category_route.dart';
import 'package:flutter_money_manager/routes/transaction_route.dart';

class Fab {
  FloatingActionButton transactionFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TransactionRoute()));
      },
      backgroundColor: Colors.white70,
      icon: Icon(Icons.add),
      label: Text('Transaction'),
    );
  }

  FloatingActionButton categoryFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CategoryRoute()));
      },
      backgroundColor: Colors.white70,
      icon: Icon(Icons.add),
      label: Text('Category'),
    );
  }
}
