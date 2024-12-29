import 'package:intl/intl.dart';

class ActivityStatusService {
  // Hàm để so sánh ngày với ngày hiện tại
  static String getStatusForOnce(String onceDate) {
    final DateTime now = DateTime.now();
    final DateTime activityDate = DateFormat('dd/MM/yyyy').parse(onceDate);

    if (activityDate.isAtSameMomentAs(now)) {
      return 'Today';
    } else if (activityDate.isAfter(now)) {
      return 'Upcoming';
    } else {
      return 'Completed';
    }
  }

  // Hàm để xác định trạng thái cho Weekly
  static String getStatusForWeekly(String weeklyDate) {
  final DateTime now = DateTime.now();
  final int todayWeekday = now.weekday; // Monday = 1, Sunday = 7

  // Ánh xạ "Sun" thành 7 (vì Dart sử dụng Sunday = 7), các ngày còn lại giữ nguyên
  final List<int> weeklyDays = weeklyDate.split(',')
      .map((day) {
        if (day.trim() == "Sun") {
          return 7; // Ánh xạ "Sun" thành 7
        } else {
          return int.tryParse(day.trim()) ?? -1; // Các ngày còn lại giữ nguyên số
        }
      })
      .where((day) => day != -1) // Loại bỏ các giá trị không hợp lệ
      .toList();

  // Kiểm tra xem ngày hôm nay có nằm trong weeklyDays không
  if (weeklyDays.contains(todayWeekday)) {
    return 'Today';
  } else {
    return 'Upcoming';
  }
}





  // Hàm để xác định trạng thái cho Monthly
  static String getStatusForMonthly(String monthlyDate) {
  final DateTime now = DateTime.now();
  final int todayDay = now.day;
  final int activityDay = int.parse(monthlyDate.split(' ')[0]); // Lấy ngày từ "20 Monthly"

  if (activityDay == todayDay) {
    return 'Today';
  } else if (activityDay > todayDay) {
    return 'Upcoming';
  } else {
    return 'Completed';
  }
}

  // Daily luôn luôn là Today
  static String getStatusForDaily() {
    return 'Today';
  }
}