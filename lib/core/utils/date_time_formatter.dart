import 'package:intl/intl.dart';

class DateFormatterUtil {
  static String call(String dateTimeString) {
    final DateTime currentDate = DateTime.now();
    final DateTime createdAt =
        DateFormat('MM/dd/yyyy, HH:mm:ss a').parse(dateTimeString);

    final difference = currentDate.difference(createdAt);

    var differeneInMinutes = difference.inMinutes;
    var differenceInHours = difference.inHours;
    var differenceInDays = difference.inDays;

    if (differeneInMinutes <= 2) return "Just Now";
    if (differeneInMinutes > 2 && differeneInMinutes < 59) {
      return "$differeneInMinutes mins ago";
    }

    if (differenceInHours >= 1 && differenceInHours < 24) {
      return "$differenceInHours ${differenceInHours == 1 ? "hour" : "hours"} ago";
    }

    return "$differenceInDays ${differenceInDays == 1 ? "day" : "days"} ago";
  }

  static DateTime parseDate(String dateTimeString) {
    return DateFormat('MM/dd/yyyy, HH:mm:ss a').parse(dateTimeString);
  }
}
