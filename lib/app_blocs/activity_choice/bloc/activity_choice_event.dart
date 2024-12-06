part of 'activity_choice_bloc.dart';

@immutable
sealed class ActivityChoiceEvent {}

class SelectChoiceEvent extends ActivityChoiceEvent {
  final String groupId;
  final String activityId;
  final String userId;
  final String choice;

  SelectChoiceEvent(
    this.choice,
    this.groupId,
    this.activityId,
    this.userId,
  );
}

class ResetChoiceEvent extends ActivityChoiceEvent {}

class LoadChoiceEvent extends ActivityChoiceEvent {
  final String groupId;
  final String activityId;
  final String userId;

  LoadChoiceEvent(
    this.groupId,
    this.activityId,
    this.userId,
  );
}

class CountAttendanceChoice extends ActivityChoiceEvent{
  final String groupId;
  final String activityId;
  final DateTime date;

  CountAttendanceChoice(this.groupId, this.activityId, this.date);
}

class FetchAttendanceListEvent extends ActivityChoiceEvent {
  final String groupId;
  final String activityId;

  FetchAttendanceListEvent(this.groupId, this.activityId);
}