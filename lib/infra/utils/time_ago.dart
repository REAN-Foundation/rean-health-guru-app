import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    final DateTime notificationDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateString, true).toLocal();
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate.toLocal());
    final dateFormat = DateFormat('dd MMM');
    if (difference.inDays > 8) {
      return dateFormat.format(notificationDate);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return numericDates ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return numericDates ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return numericDates ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return numericDates ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  static String timeAgoSinceByDate(DateTime date, {bool numericDates = true}) {
    final DateTime notificationDate = date;
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate.toLocal());
    final dateFormat = DateFormat('dd MMM');
    if (difference.inDays > 8) {
      return dateFormat.format(notificationDate);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return numericDates ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return numericDates ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return numericDates ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return numericDates ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  static String timeAgoForChat(DateTime date, {bool numericDates = true}) {
    final DateTime notificationDate = date;
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate.toLocal());
    final dateFormat = DateFormat('dd MMM');
    if (difference.inDays > 8) {
      return dateFormat.format(notificationDate);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return numericDates ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return numericDates ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return numericDates ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return numericDates ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
