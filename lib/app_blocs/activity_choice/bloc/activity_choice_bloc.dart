import 'dart:async';

import 'package:attendo_app/services/attendance_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'activity_choice_event.dart';
part 'activity_choice_state.dart';

class ActivityChoiceBloc extends Bloc<ActivityChoiceEvent, ActivityChoiceState> {
  final AttendanceService attendanceService;
  ActivityChoiceBloc(this.attendanceService) : super(ActivityChoiceInitial()) {
    on<SelectChoiceEvent>(_onSelectChoice);
    on<ResetChoiceEvent>(_onResetChoice);
    on<LoadChoiceEvent>(_onLoadChoiceEvent);
  }

  FutureOr<void> _onSelectChoice(SelectChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    try {
      await attendanceService.recordAttendance(event.groupId, event.activityId, event.userId, event.choice);
      emit(ActivityChoiceSelected(event.choice));
    } catch (e) {
      emit(ActivityChoiceError("Failed to record attendance: $e"));
    }
  }

  FutureOr<void> _onResetChoice(ResetChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    emit(ActivityChoiceInitial());
  }

  FutureOr<void> _onLoadChoiceEvent(LoadChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    try {
      final choice = await attendanceService.getUserAttendanceChoice(event.groupId, event.activityId, event.userId);
      if (choice != null){
        emit(ActivityChoiceSelected(choice));
      } else {
        emit(ActivityChoiceInitial());
      }
    } catch (e){
      emit(ActivityChoiceError("Failed to load choice: $e"));
    }
  }
}
