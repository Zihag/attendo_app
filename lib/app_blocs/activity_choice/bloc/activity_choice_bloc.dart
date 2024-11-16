import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'activity_choice_event.dart';
part 'activity_choice_state.dart';

class ActivityChoiceBloc extends Bloc<ActivityChoiceEvent, ActivityChoiceState> {
  ActivityChoiceBloc() : super(ActivityChoiceInitial()) {
    on<SelectChoiceEvent>(_onSelectChoice);
    on<ResetChoiceEvent>(_onResetChoice);
  }

  FutureOr<void> _onSelectChoice(SelectChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    emit(ActivityChoiceSelected(event.choice));
  }

  FutureOr<void> _onResetChoice(ResetChoiceEvent event, Emitter<ActivityChoiceState> emit) async {
    emit(ActivityChoiceInitial());
  }
}
