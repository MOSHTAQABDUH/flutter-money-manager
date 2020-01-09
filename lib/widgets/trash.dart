import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';
import 'package:flutter_money_manager/widgets/future_list_item_builder.dart';
import 'package:flutter_money_manager/widgets/heading_item_tile.dart';
import 'package:flutter_money_manager/widgets/transaction_item_tile.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  void _showOptionsModalBottomSheet(
    BuildContext context,
    MyTransaction transaction,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.restore),
                  title: new Text('Restore'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Repository().restoreTransaction(transaction.id);
                    setState(() {});
                  }),
            ],
          );
        });
  }

  Future<void> _showEmptyTrashConfirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empty Trash?'),
          content: Text('All transactions in the Trash will be'
              ' permanently deleted.'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () async {
                await Repository().deleteBackupTransactions();
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget _listItemBuilder(List<ListItem> items) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Items that have been in Trash more than 30 days will be'
            ' automatically deleted.',
            style: Theme.of(context).textTheme.caption,
          ),
          subtitle: FlatButton(
            onPressed: () async {
              _showEmptyTrashConfirmDialog(context);
            },
            child: Text(
              'Empty trash now',
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
        ),
        Divider(),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (items[index] is HeadingItem) {
                  return HeadingItemTile(
                    index: index,
                    item: items[index] as HeadingItem,
                  );
                } else {
                  TransactionItem item = items[index] as TransactionItem;
                  return TransactionItemTile(
                    item: item,
                    onLongPress: () => _showOptionsModalBottomSheet(
                      context,
                      item.transaction,
                    ),
                  );
                }
              },
              itemCount: items.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    Repository().deleteOldTransaction(30);
  }

  @override
  Widget build(BuildContext context) {
    return FutureListItemBuilder(
      deleted: true,
      transactionFilterType: TransactionFilterType.DAILY,
      loadingBuilderFn: (BuildContext context1) {
        return CircularProgressIndicator();
      },
      listItemBuilderFn: (
        BuildContext context2,
        List<ListItem> listItems,
      ) {
        return _listItemBuilder(listItems);
      },
      emptyDataBuilderFn: (BuildContext context3) {
        return Hint(
          iconData: Icons.restore_from_trash,
          hint: 'Nothing in Trash',
        );
      },
      errorBuilderFn: (BuildContext context4, String error) {
        return Center(
          child: Text(error),
        );
      },
    );
  }
}
