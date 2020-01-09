import 'package:flutter/material.dart';

final _borderRadius = BorderRadius.circular(30);

class CustomTabbarItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  final bool selected;
  final Color selectedColor;

  const CustomTabbarItem({
    Key key,
    @required this.onTap,
    @required this.child,
    this.selected = false,
    this.selectedColor = Colors.white24,
  })  : assert(onTap != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: _borderRadius,
      color: selected ? selectedColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: _borderRadius,
        highlightColor: selectedColor,
        splashColor: selectedColor,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          child: child,
        ),
      ),
    );
  }
}

class CustomTabbar extends StatefulWidget {
  final List<CustomTabbarItem> customTabbarItems;
  final int selectedIndex;
  final Color color;

  const CustomTabbar({
    Key key,
    @required this.customTabbarItems,
    @required this.selectedIndex,
    this.color = Colors.black26,
  })  : assert(customTabbarItems != null && customTabbarItems.length > 1),
        assert(selectedIndex != null &&
            selectedIndex > -1 &&
            selectedIndex < customTabbarItems.length),
        assert(color != null),
        super(key: key);

  @override
  _CustomTabbarState createState() => _CustomTabbarState(
        customTabbarItems: customTabbarItems,
        selectedIndex: selectedIndex,
        color: color,
      );
}

class _CustomTabbarState extends State<CustomTabbar> {
  final List<CustomTabbarItem> customTabbarItems;
  int selectedIndex;
  final Color color;

  _CustomTabbarState({
    @required this.customTabbarItems,
    @required this.selectedIndex,
    @required this.color,
  })  : assert(customTabbarItems != null && customTabbarItems.length > 1),
        assert(selectedIndex != null &&
            selectedIndex > -1 &&
            selectedIndex < customTabbarItems.length),
        assert(color != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < customTabbarItems.length; i++) {
      list.add(Expanded(
        child: CustomTabbarItem(
          onTap: () {
            setState(() {
              customTabbarItems[i].onTap();
              selectedIndex = i;
            });
          },
          child: customTabbarItems[i].child,
          selected: selectedIndex == i,
          selectedColor: customTabbarItems[i].selectedColor,
        ),
      ));
    }

    return Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: _borderRadius,
      ),
      child: Row(
        children: list,
      ),
    );
  }
}
