part of 'today_activity_bloc.dart';

@immutable
sealed class TodayActivityState {}

final class TodayActivityInitial extends TodayActivityState {}

final class TodayActivityLoading extends TodayActivityState{}

final class TodayActivityLoaded extends TodayActivityState{
  final List<Map<String, dynamic>> activities;

  TodayActivityLoaded(this.activities);

}

final class TodayActivityError extends TodayActivityState{
  final String message;

  TodayActivityError(this.message);
}