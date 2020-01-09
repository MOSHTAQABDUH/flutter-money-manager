import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

typedef TransactionListBuilderFn = Widget Function(
  BuildContext context,
  List<MyTransaction> transactions,
);

class FutureTransactionListBuilder extends StatefulWidget {
  final TransactionFilterType transactionFilterType;
  final bool deleted;
  final LoadingBuilderFn loadingBuilderFn;
  final TransactionListBuilderFn transactionListBuilderFn;
  final EmptyDataBuilderFn emptyDataBuilderFn;
  final ErrorBuilderFn errorBuilderFn;

  const FutureTransactionListBuilder({
    Key key,
    @required this.transactionFilterType,
    @required this.loadingBuilderFn,
    @required this.transactionListBuilderFn,
    @required this.emptyDataBuilderFn,
    @required this.errorBuilderFn,
    this.deleted = false,
  })  : assert(transactionFilterType != null),
        assert(deleted != null),
        assert(loadingBuilderFn != null),
        assert(transactionListBuilderFn != null),
        assert(emptyDataBuilderFn != null),
        assert(errorBuilderFn != null),
        super(key: key);

  @override
  _FutureTransactionListBuilderState createState() =>
      _FutureTransactionListBuilderState();
}

class _FutureTransactionListBuilderState
    extends State<FutureTransactionListBuilder> {
  bool _loading = true;
  String _error;
  List<MyTransaction> _transactions;

  void _fetchTransactions() {
    Repository()
        .getTransactions(
      transactionFilterType: TransactionFilterType.ALL,
      deleted: false,
    )
        .then((List<MyTransaction> myTransactions) {
      setState(() {
        _loading = false;
        _transactions = myTransactions;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
        _transactions = null;
        this._error = 'Fail to fetch transactions';
      });
    });
  }

  @override
  void initState() {
    _fetchTransactions();
    super.initState();
  }

  @override
  void didUpdateWidget(FutureTransactionListBuilder oldWidget) {
    _fetchTransactions();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return widget.loadingBuilderFn(context);
    } else if (_transactions != null && _transactions.isEmpty) {
      return widget.emptyDataBuilderFn(context);
    } else if (_transactions != null && _transactions.isNotEmpty) {
      return widget.transactionListBuilderFn(context, _transactions);
    } else {
      return widget.errorBuilderFn(context, _error);
    }
  }
}
