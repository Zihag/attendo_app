// import 'dart:async';

// import 'package:attendo_app/services/attendance_service.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';

// part 'attendance_event.dart';
// part 'attendance_state.dart';

// class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
//   final AttendanceService _attendanceService;
//   AttendanceBloc(this._attendanceService) : super(AttendanceInitial()) {
//     on<RecordAttendance>(_onRecordAttendance);
//     on<LoadAttendance>(_onLoadAttendance);
//     on<CountAttendanceChoices>(_onCountAttendanceChoices);
//   }

//   FutureOr<void> _onRecordAttendance(RecordAttendance event, Emitter<AttendanceState> emit) async {
//     emit(AttendanceLoading());
//     try{
//       await _attendanceService.recordAttendance(event.groupId, event.activityId, event.userId, event.status);
//       emit(AttendanceRecorded());
//     } catch (e){
//       emit(AttendanceError("Failed to record attendance: ${e.toString()}"));
//     }
//   }

//   FutureOr<void> _onLoadAttendance(LoadAttendance event, Emitter<AttendanceState> emit) async {
//     emit(AttendanceLoading());
//     try {
//       final attendanceList = await _attendanceService.loadAttendance(event.groupId, event.activityId, event.date);
//       emit(AttendanceLoaded(attendanceList));
//     } catch (e){
//       emit(AttendanceError("Failed to load attendance ${e.toString()}"));
//     }
//   }

//   FutureOr<void> _onCountAttendanceChoices(CountAttendanceChoices event, Emitter<AttendanceState> emit) async {
//     emit(AttendanceLoading());
//     try{
//       final counts = await _attendanceService.countAttendanceChoices(event.groupId, event.activityId, DateTime.now());
//       final yesCount = counts['Yes']??0;
//       final noCount = counts['No']??0;
//       emit(AttendanceChoicesCounted(yesCount, noCount));
//     } catch (e){
//       emit(AttendanceError("Failed to count attendance choices: ${e.toString()}"));
//     }
//   }
// }
