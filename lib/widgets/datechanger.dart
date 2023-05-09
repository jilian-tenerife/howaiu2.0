import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DayOfWeekDate extends StatelessWidget {
  const DayOfWeekDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Call initializeDateFormatting with the appropriate locale
    initializeDateFormatting('fil_PH');

    // Get the user's local time zone
    final userTimeZone = DateTime.now().timeZoneOffset;

    // Use the intl package to format the date string with the correct time zone and locale
    final formattedDate = DateFormat('M/d/yyyy', 'fil_PH')
        .format(DateTime.now().toUtc().add(userTimeZone));

    return Scaffold(
      backgroundColor: Color(0xff5D7599),
      body: Center(
        child: Text(
          formattedDate,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
