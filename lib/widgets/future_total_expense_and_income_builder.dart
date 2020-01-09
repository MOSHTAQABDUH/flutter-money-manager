import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

typedef TotalBuilderFn = Widget Function(
  BuildContext context,
  Map<TransactionType, double> map,
);

class FutureTotalExpenseAndIncomeBuilder extends StatefulWidget {
  const FutureTotalExpenseAndIncomeBuilder({
    Key key,
    @required this.loadingBuilderFn,
    @required this.totalBuilderFn,
    @required this.emptyDataBuilderFn,
    @required this.errorBuilderFn,
  })  : assert(loadingBuilderFn != null),
        assert(totalBuilderFn != null),
        assert(emptyDataBuilderFn != null),
        assert(errorBuilderFn != null),
        super(key: key);

  final LoadingBuilderFn loadingBuilderFn;
  final TotalBuilderFn totalBuilderFn;
  final EmptyDataBuilderFn emptyDataBuilderFn;
  final ErrorBuilderFn errorBuilderFn;

  @override
  _FutureTotalExpenseAndIncomeBuilderState createState() =>
      _FutureTotalExpenseAndIncomeBuilderState();
}

class _FutureTotalExpenseAndIncomeBuilderState
    extends State<FutureTotalExpenseAndIncomeBuilder> {
  bool _loading = true;
  String _error;
  Map<TransactionType, double> _map;

  void _fetchTotalExpenseAndIncome() {
    Repository()
        .getTotalExpenseAndIncome()
        .then((Map<TransactionType, double> map) {
      setState(() {
        _loading = false;
        _map = map;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
        _map = null;
        this._error = 'Fail to fetch total expense and income';
      });
    });
  }

  @override
  void initState() {
    _fetchTotalExpenseAndIncome();
    super.initState();
  }

  @override
  void didUpdateWidget(FutureTotalExpenseAndIncomeBuilder oldWidget) {
    _fetchTotalExpenseAndIncome();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return widget.loadingBuilderFn(context);
    } else if (_map != null && _map.isEmpty) {
      return widget.emptyDataBuilderFn(context);
    } else if (_map != null && _map.isNotEmpty) {
      return widget.totalBuilderFn(context, _map);
    } else {
      return widget.errorBuilderFn(context, _error);
    }
  }
}
