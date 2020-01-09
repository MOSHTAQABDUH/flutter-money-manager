import 'package:flutter/material.dart';

typedef LoadingBuilderFn = Widget Function(BuildContext context);
typedef EmptyDataBuilderFn = Widget Function(BuildContext context);
typedef ErrorBuilderFn = Widget Function(BuildContext context, String error);

class Hint extends StatelessWidget {
  const Hint({
    Key key,
    @required this.iconData,
    @required this.hint,
  })  : assert(iconData != null),
        assert(hint != null),
        super(key: key);

  final IconData iconData;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            iconData,
            size: 150.0,
            color: Colors.white70,
          ),
          Text(
            hint,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}