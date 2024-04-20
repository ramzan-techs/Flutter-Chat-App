import 'package:flutter/material.dart';

class MyDateUtil {
  static String getformattedDate(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime date = DateTime.now();
    if (date.day == sent.day &&
        date.month == sent.month &&
        date.year == sent.year) {
      return TimeOfDay.fromDateTime(date).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  // for getting format of last active time
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final i = int.tryParse(lastActive) ?? -1;

    if (i == -1) {
      return 'Last seen is not available';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen today at ${formattedTime}';
    }

    if ((now.difference(time).inHours / 24).floor() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month at $formattedTime';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }

    return 'NA';
  }
}
