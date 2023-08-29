import 'package:intl/intl.dart';

final cForm = NumberFormat('###0.00', Intl.getCurrentLocale());
final qForm = NumberFormat('###0.###', Intl.getCurrentLocale());

String currencyFormatter(double value) {
  return cForm.format(value);
}

String quantityFormatter (double value) {
  return qForm.format(value);
}