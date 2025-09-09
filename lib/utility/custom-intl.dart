class DateFormatter {
  /// yyyy-MM-dd HH:mm:ss
  static String formatDateTime(DateTime dateTime) {
    String year = dateTime.year.toString().padLeft(4, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');

    return "$year-$month-$day $hour:$minute:$second";
  }

  /// dd MMM yyyy → 09 Sep 2025
  static String formatReadableDate(DateTime dateTime) {
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    String day = dateTime.day.toString().padLeft(2, '0');
    String month = months[dateTime.month - 1];
    String year = dateTime.year.toString();

    return "$day $month $year";
  }

  /// hh:mm a → 08:45 PM
  static String formatTime12h(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String ampm = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12;

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm";
  }
}
