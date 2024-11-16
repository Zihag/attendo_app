part of 'activity_choice_bloc.dart';

@immutable
sealed class ActivityChoiceEvent {}

class SelectChoiceEvent extends ActivityChoiceEvent{
  final String choice;

  SelectChoiceEvent(this.choice);
}

class ResetChoiceEvent extends ActivityChoiceEvent {}
