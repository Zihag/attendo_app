// part of 'attendance_bloc.dart';

// @immutable
// sealed class AttendanceEvent {}

// class RecordAttendance extends AttendanceEvent {
//   final String groupId;
//   final String activityId;
//   final String userId;
//   final String status;

//   RecordAttendance(
//       {required this.groupId,
//       required this.activityId,
//       required this.userId,
//       required this.status});
// }


// class LoadAttendance extends AttendanceEvent{
//   final String groupId;
//   final String activityId;
//   final DateTime date;

//   LoadAttendance({required this.groupId, required this.activityId, required this.date});
// }

// class CountAttendanceChoices extends AttendanceEvent{
//   final String groupId;
//   final String activityId;
//   final DateTime date;

//   CountAttendanceChoices(this.groupId, this.activityId, this.date);
// }