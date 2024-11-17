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
