import 'dart:async';

import 'package:attendo_app/services/today_activity_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'today_activity_event.dart';
part 'today_activity_state.dart';

class TodayActivityBloc extends Bloc<TodayActivityEvent, TodayActivityState> {
  final TodayActivityService _todayActivityService;
  TodayActivityBloc(this._todayActivityService) : super(TodayActivityInitial()) {
    on<LoadTodayActivities>(_onLoadTodayActivities);
  }

  FutureOr<void> _onLoadTodayActivities(LoadTodayActivities event, Emitter<TodayActivityState> emit) async {
    emit(TodayActivityLoading());
    print('Emit: TodayActivityLoading');
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid??'';
      final activities = await _todayActivityService.fetchTodayActivities(userId);
      emit(TodayActivityLoaded(activities));
    } catch(e){
      emit(TodayActivityError("Failed to load today's activities: ${e.toString()}"));
    }
  }
}
