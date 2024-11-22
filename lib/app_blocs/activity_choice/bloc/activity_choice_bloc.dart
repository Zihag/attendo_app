import 'dart:async';

import 'package:attendo_app/app_blocs/attendance/bloc/attendance_bloc.dart';
import 'package:attendo_app/services/attendance_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'activity_choice_event.dart';
part 'activity_choice_state.dart';

class ActivityChoiceBloc
    extends Bloc<ActivityChoiceEvent, ActivityChoiceState> {
  final AttendanceService attendanceService;
  ActivityChoiceBloc(this.attendanceService) : super(ActivityChoiceInitial()) {
    on<SelectChoiceEvent>(_onSelectChoice);
    on<ResetChoiceEvent>(_onResetChoice);
    on<LoadChoiceEvent>(_onLoadChoiceEvent);
    on<CountAttendanceChoice>(_onCountAttendanceChoices);
  }

  FutureOr<void> _onSelectChoice(
      SelectChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    try {
      print('SelectChoiceEvent received: ${event.choice}');
      await attendanceService.recordAttendance(
          event.groupId, event.activityId, event.userId, event.choice);

      final counts = await attendanceService.countAttendanceChoices(event.groupId, event.activityId, DateTime.now());
      
      emit(ActivityChoiceUpdated(selectedChoice: event.choice, yesCount: counts['Yes']??0, noCount: counts['No']??0));
      print('Choice succesfully recorded: ${event.choice}');
    } catch (e) {
      print('Error recording choice: $e');
      emit(ActivityChoiceError("Failed to record attendance: $e"));
    }
  }

  FutureOr<void> _onResetChoice(
      ResetChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    emit(ActivityChoiceInitial());
  }

  FutureOr<void> _onLoadChoiceEvent(
      LoadChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    try {
      final choice = await attendanceService.getUserAttendanceChoice(
          event.groupId, event.activityId, event.userId);

          final counts = await attendanceService.countAttendanceChoices(event.groupId, event.activityId, DateTime.now());
          final yesCount = counts['Yes']??0;
          final noCount = counts['No']??0;
      if (choice != null) {
        emit(ActivityChoiceUpdated(selectedChoice: choice, yesCount: yesCount, noCount: noCount));
      } else {
        emit(ActivityChoiceInitial());
      }
    } catch (e) {
      emit(ActivityChoiceError("Failed to load choice: $e"));
    }
  }

  FutureOr<void> _onCountAttendanceChoices(
      CountAttendanceChoice event, Emitter<ActivityChoiceState> emit) async {
    emit(ActivityChoiceLoading());
    try {
      final counts = await attendanceService.countAttendanceChoices(
          event.groupId, event.activityId, DateTime.now());
      final yesCount = counts['Yes'] ?? 0;
      final noCount = counts['No'] ?? 0;
      print(yesCount);
      print(noCount);
      emit(ActivityChoicesCounted(yesCount, noCount));
    } catch (e) {
      emit(ActivityChoiceError(
          "Failed to count activity choices: ${e.toString()}"));
    }
  }
}
