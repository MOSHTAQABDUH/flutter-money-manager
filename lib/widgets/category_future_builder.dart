import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

typedef CategoryListViewBuilderFn = Widget Function(
  BuildContext context,
  List<Category> categories,
);

class CategoryFutureBuilder extends StatefulWidget {
  const CategoryFutureBuilder({
    Key key,
    @required this.loadingBuilderFn,
    @required this.categoryListviewBuilderFn,
    @required this.emptyDataBuilderFn,
    @required this.errorBuilderFn,
    @required this.transactionType,
  })  : assert(loadingBuilderFn != null),
        assert(categoryListviewBuilderFn != null),
        assert(emptyDataBuilderFn != null),
        assert(errorBuilderFn != null),
        super(key: key);

  final LoadingBuilderFn loadingBuilderFn;
  final CategoryListViewBuilderFn categoryListviewBuilderFn;
  final EmptyDataBuilderFn emptyDataBuilderFn;
  final ErrorBuilderFn errorBuilderFn;
  final TransactionType transactionType;

  @override
  _CategoryFutureBuilderState createState() => _CategoryFutureBuilderState();
}

class _CategoryFutureBuilderState extends State<CategoryFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Repository().fetchCategories(widget.transactionType),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return widget.errorBuilderFn(context, snapshot.error.toString());
          } else if (snapshot.data.isEmpty) {
            return widget.emptyDataBuilderFn(context);
          } else {
            return widget.categoryListviewBuilderFn(context, snapshot.data);
          }
        } else {
          return widget.loadingBuilderFn(context);
        }
      },
    );
  }
}
