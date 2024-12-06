part of 'activity_choice_bloc.dart';

@immutable
sealed class ActivityChoiceState {}

final class ActivityChoiceInitial extends ActivityChoiceState {}

class ActivityChoiceLoading extends ActivityChoiceState{}

class ActivityChoiceSelected extends ActivityChoiceState {
  final String activityId;
  final String selectedChoice;

  ActivityChoiceSelected(this.selectedChoice, this.activityId);
}

class ActivityChoiceError extends ActivityChoiceState {
  final String message;

  ActivityChoiceError(this.message);
}

class ActivityChoicesCounted extends ActivityChoiceState{
  final int yesCount;
  final int noCount;

  ActivityChoicesCounted(this.yesCount, this.noCount);
}

class ActivityChoiceUpdated extends ActivityChoiceState {
  final String? selectedChoice;
  final int yesCount;
  final int noCount;

  ActivityChoiceUpdated({required this.selectedChoice, required this.yesCount, required this.noCount});
}

class AttendanceListLoaded extends ActivityChoiceState {
  final List<String> yesList;
  final List<String> noList;

  AttendanceListLoaded({required this.yesList, required this.noList});
}