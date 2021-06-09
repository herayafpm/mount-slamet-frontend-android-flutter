import 'package:intl/intl.dart';

abstract class DateTimeUtil {
  static String onlyDate(DateTime dateTime) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  static String convert(DateTime dateTime) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  static DateTime toDate(String datetime) {
    return DateFormat("yyyy-MM-dd").parse(datetime);
  }

  static String toDateHumanize(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    return DateFormat("dd-MM-yyyy H.mm").format(dateTime);
  }

  static String toDateTime(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(dateTime);
  }

  static String humanize(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    return DateFormat("dd MMMM yyyy H.mm").format(dateTime);
  }
}
