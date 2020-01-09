import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';

class HeadingItemTile extends StatelessWidget {
  const HeadingItemTile({
    Key key,
    @required this.index,
    @required this.item,
    this.showTotal = false,
  })  : assert(index != null),
        assert(item != null),
        assert(showTotal != null),
        super(key: key);

  final int index;
  final HeadingItem item;
  final bool showTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        index == 0 ? SizedBox(height: 4.0) : Divider(),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 8.0,
            right: 16.0,
            bottom: 8.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(item.heading)),
              showTotal
                  ? Text(
                      standardNumberFormat(item.balance),
                      style: TextStyle(
                        color: item.balance < 0 ? Colors.red : Colors.green,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
