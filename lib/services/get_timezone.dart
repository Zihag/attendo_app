import 'package:flutter_timezone/flutter_timezone.dart';

class GetTimeZone {
  Future<String> getTimeZone() async {
    String timeZone = await FlutterTimezone.getLocalTimezone();
    return timeZone;
  }
}
