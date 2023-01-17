import 'package:intl/intl.dart';

class DateFormatterUtil {
  static String formatProductCreatedAtTime(
    String dateTimeString,
    String language,
  ) {
    final DateTime currentDate = DateTime.now();
    final DateTime createdAt = DateFormat('yyyy-MM-ddTHH:mm:ss')
        .parse(dateTimeString)
        .add(const Duration(hours: 3));

    final difference = currentDate.difference(createdAt);

    var differenceInMinutes = difference.inMinutes;
    var differenceInHours = difference.inHours;
    var differenceInDays = difference.inDays;

    if (differenceInMinutes <= 2) return language == "en" ? "Just Now" : "አሁን";
    if (differenceInMinutes > 2 && differenceInMinutes < 59) {
      return "$differenceInMinutes mins ago";
    }

    if (differenceInHours >= 1 && differenceInHours < 24) {
      return "$differenceInHours ${differenceInHours == 1 ? language == "en" ? "hour" : 'ሰአት' : language == "en" ? "hours" : "ሰአታት"} ${language == "en" ? "ago" : "በፊት"}";
    }

    return "$differenceInDays ${differenceInDays == 1 ? language == "en" ? "day" : 'ቀን' : language == "en" ? "days" : "ቀናት"} ${language == "en" ? "ago" : "በፊት"}";
  }

  static DateTime parseMessageCreatedDate(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  static DateTime parseProductCreatedDate(String dateTimeString) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTimeString);
  }

  static String extractDateFromDateTime(String dateTimeString) {
    return DateFormat('MM/dd/yyyy').format(DateTime.parse(dateTimeString));
  }

  static bool compareDates(String dateOne, String dateTwo) {
    final DateTime dateTimeOne = DateFormat('MM/dd/yyyy').parse(dateOne);
    final DateTime dateTimeTwo = DateFormat('MM/dd/yyyy').parse(dateTwo);
    final difference = dateTimeOne.difference(dateTimeTwo).inDays.abs();
    return difference == 0;
  }

  static String formatUniqueMessageCreatedDate(String dateTimeString) {
    final DateTime parsed = DateFormat('MM/dd/yyyy').parse(dateTimeString);
    return DateFormat('MMMM d , yyyy').format(parsed);
  }

  static String extractTimeFromDate(String dateTimeString) {
    var formattedTime = DateTime.parse(dateTimeString);
    return DateFormat('hh:mm').format(formattedTime);
  }
}
