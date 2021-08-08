import 'package:intl/intl.dart';

String getShortTime(DateTime sentTime) =>
    DateFormat.yMEd().add_jms().format(sentTime).split(" ")[2].substring(0, 4) +
    " " +
    DateFormat.yMEd().add_jms().format(sentTime).split(" ").last;
