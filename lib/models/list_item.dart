import 'package:flutter_money_manager/models/transaction.dart';
import 'package:meta/meta.dart';

// The base class for the different types of items the list can contain.
abstract class ListItem {}

class HeadingItem implements ListItem {
  final String heading;
  final double balance;

  HeadingItem({
    @required this.heading,
    @required this.balance,
  })  : assert(heading != null),
        assert(balance != null);
}

class TransactionItem implements ListItem {
  final MyTransaction transaction;

  TransactionItem({
    @required this.transaction,
  }) : assert(transaction != null);
}
