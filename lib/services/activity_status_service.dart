import 'package:intl/intl.dart';

class ActivityStatusService {
  // Hàm để so sánh ngày với ngày hiện tại
  static String getStatusForOnce(String onceDate) {
    final DateTime now = DateTime.now();
    final DateTime activityDate = DateFormat('dd/MM/yyyy').parse(onceDate);

    //Comparing just date part
    final bool isSameDate = now.year == activityDate.year &&
      now.month == activityDate.month &&
      now.day == activityDate.day;

    if (isSameDate) {
      return 'Today';
    }else if(activityDate.isAfter(now)){
      return 'Upcoming';
    } else {
      return 'Completed';
    }
  }

  // Hàm để xác định trạng thái cho Weekly
  static String getStatusForWeekly(String weeklyDate) {
  final DateTime now = DateTime.now();
  final int todayWeekday = now.weekday; // Monday = 1, Sunday = 7

  // Ánh xạ chuỗi "Sun", "Mon",... sang số tương ứng
  final Map<String, int> dayMapping = {
    'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4,
    'Fri': 5, 'Sat': 6, 'Sun': 7,
  };

  final List<int> weeklyDays = weeklyDate.split(',')
      .map((day) => dayMapping[day.trim()] ?? -1) // Ánh xạ ngày
      .where((day) => day != -1) // Loại bỏ giá trị không hợp lệ
      .toList();

  // Kiểm tra xem ngày hôm nay có trong danh sách không
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