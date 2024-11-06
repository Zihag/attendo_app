import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TodayActivityService {
  final FirebaseFirestore _firebaseFirestore;

  TodayActivityService(this._firebaseFirestore);

  Future<List<Map<String, dynamic>>> fetchTodayActivities(String userId) async {
    final today = DateTime.now();
    final todayDate = DateFormat('yyyy-MM-dd').format(today);
    final weekday = today.weekday;
    final dayOfMonth = today.day;

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
        if (isTodayActivity) {
          todayActivities.add({
            'activityName': activityData['name'],
            'groupName': groupName,
            'actTime': actTime,
            'frequency': activityData['frequency']
          });
        }
      }
    }
    return todayActivities;
  }
}
