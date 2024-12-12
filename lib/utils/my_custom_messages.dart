import 'package:timeago/timeago.dart' as timeago;

class MyCustomMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => ' from now';
  @override
  String lessThanOneMinute(int seconds) => 'now';
  @override
  String aboutAMinute(int minutes) => '1m ago';
  @override
  String minutes(int minutes) => '${minutes}m ago';
  @override
  String aboutAnHour(int minutes) => '1h ago';
  @override
  String hours(int hours) => '${hours}h ago';
  @override
  String aDay(int hours) => '1d ago';
  @override
  String days(int days) => '${days}d ago';
  @override
  String aboutAMonth(int days) => '1mo ago';
  @override
  String months(int months) => '${months}mo ago';
  @override
  String aboutAYear(int year) => '1y ago';
  @override
  String years(int years) => '${years}y ago';
  @override
  String wordSeparator() => ' ';

  String weeks(int weeks) => '${weeks}w ago';
}

void customDates() {
  DateTime someDate =
      DateTime.now().subtract(const Duration(days: 7)); // 1 week ago
  int weeks = someDate.difference(DateTime.now()).inDays ~/ 7;

  someDate =
      DateTime.now().subtract(const Duration(days: 30)); // about a month ago

  someDate =
      DateTime.now().subtract(const Duration(days: 365)); // about a year ago
}
