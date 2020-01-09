import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_money_manager/consts.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';
import 'package:flutter_money_manager/widgets/category_usage_list_route.dart';
import 'package:flutter_money_manager/widgets/circular_progressbar_painter.dart';
import 'package:flutter_money_manager/widgets/future_transaction_list_builder.dart';

class Dashboard extends StatelessWidget {
  Widget _totalBalanceBuilder(BuildContext context, double totalBalance) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            standardNumberFormat(totalBalance),
            style: Theme.of(context).textTheme.display1.copyWith(
                  color: Colors.white,
                ),
          ),
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: normalFontSize,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalSummaryBuilder({
    BuildContext context,
    String title,
    String subTitle,
    double total,
    List<MyTransaction> transactions,
    IconData iconData,
  }) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryUsageList(
                      title: title,
                      total: total,
                      transactions: transactions,
                    )));
      },
      title: Text(standardNumberFormat(total)),
      subtitle: Text(
        subTitle,
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 18.0,
      ),
    );
  }

  Widget _dashboardBuilder(
    BuildContext context,
    List<MyTransaction> transactions,
  ) {
    double totalBalance = 0;
    double totalIncome = 0;
    double totalExpense = 0;

    List<MyTransaction> incomeTransactions = [];
    List<MyTransaction> expenseTransactions = [];

    for (MyTransaction transaction in transactions) {
      if (transaction.category.transactionType == TransactionType.INCOME) {
        totalIncome += transaction.amount;

        incomeTransactions.add(transaction);
      } else {
        totalExpense += transaction.amount;

        expenseTransactions.add(transaction);
      }
    }

    totalBalance = totalIncome - totalExpense;

    double minWidthAndHeight = min(screenWidth(context), screenWidth(context));

    minWidthAndHeight /= 2;

    final double onePercent = totalIncome / 100;
    final double expensePercent =
        onePercent > 0 ? totalExpense / onePercent : 100;
    double incomePercent = 100 - expensePercent;

    if (incomePercent < 0) {
      incomePercent = 0;
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: minWidthAndHeight,
            height: minWidthAndHeight,
            padding: EdgeInsets.all(3.0),
            child: CustomPaint(
              painter: CircularProgressBarPainter(
                lineColor: Colors.white10,
                completeColor: Colors.green,
                completePercent: incomePercent,
                width: 5,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${standardNumberFormat(incomePercent)}%',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Remaining',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 32.0),
          _totalBalanceBuilder(context, totalBalance),
          SizedBox(height: 32.0),
          _totalSummaryBuilder(
            context: context,
            title: 'Incomes',
            subTitle: 'Total Income',
            total: totalIncome,
            transactions: incomeTransactions,
          ),
          _totalSummaryBuilder(
            context: context,
            title: 'Expenses',
            subTitle: 'Total Expense',
            total: totalExpense,
            transactions: expenseTransactions,
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureTransactionListBuilder(
      transactionFilterType: TransactionFilterType.ALL,
      deleted: false,
      loadingBuilderFn: (BuildContext context) {
        return _dashboardBuilder(context, []);
      },
      transactionListBuilderFn: (
        BuildContext context,
        List<MyTransaction> transactions,
      ) {
        return _dashboardBuilder(context, transactions);
      },
      emptyDataBuilderFn: (BuildContext context) {
        return _dashboardBuilder(context, []);
      },
      errorBuilderFn: (BuildContext context, String error) {
        return _dashboardBuilder(context, []);
      },
    );
  }
}
