import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConvertService {


  //Timestamp to 'HH:mm'
  static String convertTimestampToTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm').format(dateTime);
  }


  /// Chuyển đổi `Timestamp` sang chuỗi ngày tháng năm dạng `dd/MM/yyyy`
  static String timestampToDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Chuyển đổi `Timestamp` sang chuỗi ngày dạng `dd`
  static String timestampToDay(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd').format(dateTime);
  }

  /// Chuyển đổi danh sách số (`weeklyDate`) thành chuỗi ngày trong tuần
  static String weeklyDateToString(List<dynamic> weeklyDate) {
  const List<String> daysOfWeek = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  // Chuyển đổi danh sách các số ngày thành chuỗi
  List<String> selectedDays = weeklyDate.map((day) {
    if (day == 7) {
      return 'Sun'; // Nếu là Sunday (7), hiển thị là 'Sun'
    } else {
      return daysOfWeek[day - 1]; // Nếu là ngày khác, hiển thị theo thứ tự (Mon, Tue, ...)
    }
  }).toList();

  return selectedDays.join(', '); // Nối các ngày đã chọn thành chuỗi
}

}
