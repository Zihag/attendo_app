import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final FirebaseFirestore _firebaseFirestore;
  ActivityBloc(this._firebaseFirestore) : super(ActivityInitial()) {
    on<CreateActivity>(_onCreateActivity);
    on<LoadActivities>(_onLoadActivities);
    on<DeleteActivity>(_onDeleteActivity);
  }

  //parse act TimeOfDay to DateTime
  DateTime timeOfDayToDateTime(TimeOfDay timeOfDay){
    return DateTime(2000,1,1,timeOfDay.hour, timeOfDay.minute);
  }

  FutureOr<void> _onCreateActivity(
      CreateActivity event, Emitter<ActivityState> emit) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ActivityError('User not logged in'));
        return;
      }

      DateTime actTimeDateTime = timeOfDayToDateTime(event.actTime);

      await _firebaseFirestore
          .collection('groups')
          .doc(event.groupId)
          .collection('activities')
          .add({
        'name': event.activityName,
        'description': event.description ?? "",
        'frequency': event.frequency,
        'onceDate': event.onceDate,
        'weeklyDate': event.weeklyDate,
        'monthlyDate': event.monthlyDate,
        'actTime': actTimeDateTime,
        'createBy': user.uid,
        'create_at': FieldValue.serverTimestamp(),
      });
      emit(ActivityCreatedSuccess());
    } catch (e) {
      emit(ActivityError('Failed to create activity'));
    }
  }

  FutureOr<void> _onLoadActivities(
      LoadActivities event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('groups')
          .doc(event.groupId)
          .collection('activities')
          .orderBy('create_at', descending: true)
          .get();

      final activities = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'description': doc['description'] ?? '',
                'frequency': doc['frequency'],
                'onceDate': doc['onceDate'],
                'weeklyDate': doc['weeklyDate'],
                'monthlyDate': doc['monthlyDate'],
                'actTime': doc['actTime'],
              })
          .toList();

      print("Activities: $activities");
      emit(ActivityLoaded(activities));
    } catch (e) {
      emit(ActivityError('Failed to load activities'));
    }
  }

  FutureOr<void> _onDeleteActivity(
      DeleteActivity event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      await _firebaseFirestore
          .collection('groups')
          .doc(event.groupId)
          .collection('activities')
          .doc(event.activityId)
          .delete();
      add(LoadActivities(groupId: event.groupId));
    } catch (e) {
      emit(ActivityError('Failed to delete activity'));
    }
  }
}
