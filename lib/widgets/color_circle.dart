import 'package:flutter/material.dart';

// Colored circle to use in ListTile's leading widget.
class ColorCircle extends StatelessWidget {
  final Color color;

  const ColorCircle({
    Key key,
    @required this.color,
  })  : assert(color != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      alignment: Alignment.center,
      child: CircleAvatar(
        backgroundColor: color,
        radius: 10.0,
      ),
    );
  }
}
