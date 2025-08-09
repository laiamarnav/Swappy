import 'package:intl/intl.dart';

class Dates {
  static final date = DateFormat('dd/MM/yyyy');
  static final time = DateFormat('HH:mm');
  static String ymd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
}
