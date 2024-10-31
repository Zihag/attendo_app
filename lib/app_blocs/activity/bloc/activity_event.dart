part of 'activity_bloc.dart';

@immutable
sealed class ActivityEvent {}

final class CreateActivity extends ActivityEvent {
  final String groupId;
  final String activityName;
  final String frequency;
  final String? description;
  final DateTime? onceDate;
  final List<int>? weeklyDate;
  final DateTime? monthlyDate;
  final TimeOfDay actTime;

  CreateActivity({
    required this.groupId,
    required this.activityName,
    required this.frequency,
    this.description,
    this.onceDate,
    this.weeklyDate,
    this.monthlyDate,
    required this.actTime,
  });
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
