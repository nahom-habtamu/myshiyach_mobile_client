class DateFormatterUtil {
  static String call(String dateTimeString) {
    final DateTime currentDate = DateTime.now();
    final DateTime createdAt =
        DateTime.parse(dateTimeString.replaceAll(",", ""));
    final difference = createdAt.difference(currentDate);

    var differeneInMinutes = difference.inMinutes * -1;
    var differenceInHours = difference.inHours * -1;
    var differenceInDays = difference.inDays * -1;

    if (differeneInMinutes < 2) return "Just Now";
    if (differeneInMinutes > 2 && differeneInMinutes < 59) {
      return "$differeneInMinutes minutes ago";
    }

    if (differenceInHours >= 1 && differenceInHours < 24) {
      return "$differenceInHours hours ago";
    }
    return "$differenceInDays days ago";
  }
}
