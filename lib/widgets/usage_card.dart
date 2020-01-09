import 'package:flutter/material.dart';
import 'package:flutter_money_manager/consts.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/widgets/circular_progressbar_painter.dart';

final BorderRadius _borderRadius = BorderRadius.circular(10.0);

class UsageCard extends StatefulWidget {
  const UsageCard({
    Key key,
    @required this.title,
    @required this.color,
    @required this.percent,
    @required this.amount,
  })  : assert(title != null),
        assert(color != null),
        assert(percent != null),
        assert(amount != null),
        super(key: key);

  final String title;
  final Color color;
  final double percent;
  final double amount;

  @override
  _UsageCardState createState() => _UsageCardState();
}

class _UsageCardState extends State<UsageCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: _borderRadius,
      color: Colors.black12,
      child: InkWell(
        onTap: () {
          // TODO : go to report
        },
        borderRadius: _borderRadius,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 20.0,
              alignment: Alignment.center,
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: normalFontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
            ),
            Container(
              width: 55,
              height: 55,
              child: CustomPaint(
                painter: CircularProgressBarPainter(
                  lineColor: Colors.white10,
                  completeColor: widget.color,
                  completePercent: widget.percent,
                  width: 5,
                ),
                child: Center(
                  child: Text(
                    '${standardNumberFormat(widget.percent)}%',
                    style: TextStyle(
                      fontSize: normalFontSize,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              standardNumberFormat(widget.amount),
              style: TextStyle(
                fontSize: normalFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
