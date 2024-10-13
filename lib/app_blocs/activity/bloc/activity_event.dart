part of 'activity_bloc.dart';

@immutable
sealed class ActivityEvent {}

final class CreateActivity extends ActivityEvent {
  final String groupId;
  final String activityName;
  final String description;
  final DateTime startTime;
  final String frequency;

  CreateActivity(
      {required this.groupId,
      required this.activityName,
      required this.description,
      required this.startTime,
      required this.frequency});
}

final class LoadActivities extends ActivityEvent {
  final String groupId;

  LoadActivities({required this.groupId});
}

final class DeleteActivity extends ActivityEvent {
  final String activityId;
  final String groupId;

  DeleteActivity({
    required this.activityId,
    required this.groupId,
  });
}
