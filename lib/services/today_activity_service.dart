import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TodayActivityService {
  final FirebaseFirestore _firebaseFirestore;

  TodayActivityService(this._firebaseFirestore);

  Future<List<Map<String, dynamic>>> fetchTodayActivities(String userId) async {
    final now = DateTime.now();
    final todayDate = DateFormat('yyyy-MM-dd').format(now);
    final weekday = now.weekday;
    final dayOfMonth = now.day;

    List<Map<String, dynamic>> todayActivities = [];

    final groupQuerySnapshot = await _firebaseFirestore
        .collection('groups')
        .where('member', arrayContains: {'userId': userId}).get();

    for (var groupDoc in groupQuerySnapshot.docs) {
      final groupId = groupDoc.id;
      final groupName = groupDoc['name'];

      final activityQuerySnapshot = await _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .collection('activities')
          .get();
      for (var activityDoc in activityQuerySnapshot.docs) {
        final activityId = activityDoc.id;
        final activityData = activityDoc.data();
        final frequency = activityData['frequency'];
        final actTime = activityData['actTime'];

        bool isTodayActivity = false;

        switch (frequency) {
          case 'Once':
            final onceDate = activityData['onceDate'] as Timestamp?;
            if (onceDate != null) {
              final onceDateString =
                  DateFormat('yyyy-MM-dd').format(onceDate.toDate());
              if (onceDateString == todayDate) isTodayActivity = true;
            }
            break;
          case 'Daily':
            isTodayActivity = true;
            break;
          case 'Weekly':
            final weeklyDates =
                List<int>.from(activityData['weeklyDate'] ?? []);
            if (weeklyDates.contains(weekday)) isTodayActivity = true;
            break;
          case 'Monthly':
            final monthlyDate = activityData['monthlyDate'] as Timestamp?;
            if (monthlyDate != null) {
              final monthlyDay = monthlyDate.toDate().day;
              if (monthlyDay == dayOfMonth) isTodayActivity = true;
            }
            break;
        }
        if (isTodayActivity && actTime != null) {
          final scheduledTime = DateFormat('HH:mm').parse(actTime);
          final currentTime =
              DateTime(now.year, now.month, now.day, now.hour, now.minute);

          if (currentTime.isBefore(DateTime(now.year, now.month, now.day,
              scheduledTime.hour, scheduledTime.minute))) {
            todayActivities.add({
              'activityName': activityData['name'],
              'groupName': groupName,
              'actTime': actTime,
              'frequency': activityData['frequency'],
              'groupId': groupId,
              'activityId': activityId
            });
          }
        }
      }
    }
    return todayActivities;
  }
}
