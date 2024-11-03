part of 'today_activity_bloc.dart';

@immutable
sealed class TodayActivityEvent {}

class LoadTodayActivities extends TodayActivityEvent{
}