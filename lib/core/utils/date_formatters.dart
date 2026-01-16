import 'package:intl/intl.dart';

String formatShortDay(DateTime date) => DateFormat('EEE, MMM d').format(date);

String getLastUpdated(DateTime date) => DateFormat('MMM dd HH:mm').format(date);
