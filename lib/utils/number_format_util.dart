import 'package:intl/intl.dart';

String standardNumberFormat(double value) {
  return new NumberFormat('#,###.##').format(value);
}

String excludeZeroDecimal(double value) {
  return new NumberFormat('#.##').format(value);
}
