import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/utils/number_util.dart';
import 'package:flutter_money_manager/widgets/usage_card.dart';

class CategoryUsageList extends StatelessWidget {
  const CategoryUsageList({
    Key key,
    @required this.title,
    @required this.total,
    @required this.transactions,
  })  : assert(title != null),
        assert(total != null),
        assert(transactions != null),
        super(key: key);

  final String title;
  final double total;
  final List<MyTransaction> transactions;

  Widget _transactionCardsBuilder({
    BuildContext context,
    double total,
    List<MyTransaction> transactions,
  }) {
    transactions.sort(
        (MyTransaction a, MyTransaction b) => (b.amount - a.amount).round());
    return GridView.count(
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      padding: EdgeInsets.all(16.0),
      children: transactions.map((transaction) {
        return UsageCard(
          title: transaction.category.name,
          color: transaction.category.color,
          percent: calculatePercent(total, transaction.amount),
          amount: transaction.amount,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.0,
        ),
        centerTitle: true,
        elevation: 0.0,
        title: Text(title),
      ),
      body: _transactionCardsBuilder(
        context: context,
        total: total,
        transactions: transactions,
      ),
    );
  }
}
