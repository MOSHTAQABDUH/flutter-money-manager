import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/widgets/color_circle.dart';

class TransactionItemTile extends StatelessWidget {
  const TransactionItemTile({
    Key key,
    @required this.item,
    this.onTap,
    this.onLongPress,
  })  : assert(item != null),
        super(key: key);

  final TransactionItem item;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    String description = (item.transaction.description == null ||
            item.transaction.description.trim().isEmpty)
        ? null
        : item.transaction.description;

    double amount = item.transaction.amount;

    if (item.transaction.category.transactionType == TransactionType.EXPENSE) {
      amount *= -1;
    }

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: ColorCircle(color: item.transaction.category.color),
      title: Text(
        item.transaction.category.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: description == null ? null : Text(description),
      trailing: Text(
        standardNumberFormat(amount),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
