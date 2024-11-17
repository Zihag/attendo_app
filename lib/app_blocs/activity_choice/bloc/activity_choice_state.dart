part of 'activity_choice_bloc.dart';

@immutable
sealed class ActivityChoiceState {}

final class ActivityChoiceInitial extends ActivityChoiceState {}

class ActivityChoiceSelected extends ActivityChoiceState {
  final String selectedChoice;

  ActivityChoiceSelected(this.selectedChoice);
}

class ActivityChoiceError extends ActivityChoiceState {
  final String message;

  ActivityChoiceError(this.message);
}