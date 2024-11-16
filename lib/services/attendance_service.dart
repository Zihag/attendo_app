import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> recordAttendance(
    String groupId,
    String activityId,
    String userId,
    String status,
  ) async {
    try {
      final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final attendanceChoicesRef = _firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .collection('activities')
          .doc(activityId)
          .collection('attendanceRecords')
          .doc(dateKey)
          .collection('attendanceChoices')
          .doc(userId);

      await attendanceChoicesRef.set({
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error recording attendance: $e");
    }
  }

  Future<List<Map<String, dynamic>>> loadAttendance(
      String groupId, String activityId, DateTime date) async {
        try{
final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final attendanceChoicesRef = _firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('activities')
        .doc(activityId)
        .collection('attendanceRecords')
        .doc(dateKey)
        .collection('attendanceChoices');

    final querySnapshot = await attendanceChoicesRef.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'userId': doc.id,
        ...data,
      };
    }).toList();
        } catch (e) {
          throw Exception("Error loading attendance: $e");
        }
  }
}
