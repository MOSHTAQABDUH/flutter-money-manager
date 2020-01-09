import 'package:flutter/material.dart';

class ColorTile extends StatelessWidget {
  final bool selected;
  final Color color;
  final ValueChanged<Color> onTap;

  const ColorTile({
    Key key,
    this.selected = false,
    @required this.color,
    @required this.onTap,
  })  : assert(selected != null),
        assert(color != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onTap(color),
        customBorder: CircleBorder(),
        child: Container(
          width: 24.0,
          height: 24.0,
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Colors.white10 : Colors.transparent,
          ),
          child: Card(
            color: color,
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }
}
