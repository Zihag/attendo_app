import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  FutureOr<void> _onCreateActivity(CreateActivity event, Emitter<ActivityState> emit) async {
    emit(AcitvityLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if(user == null){
        emit(ActivityError('User not logged in'));
        return;
      }
      await _firebaseFirestore.collection('group').doc(event.groupId).collection('activities').add(
        {
          'name': event.activityName,
          'description':event.description,
          'startTime':event.startTime,
          'frequency': event.frequency,
          'createBy': user.uid,
          'create_at': FieldValue.serverTimestamp(),
        }
      );
      add(LoadActivities(groupId: event.groupId));
    } catch(e){
      emit(ActivityError('Failed to create activity'));
    }
  }

  FutureOr<void> _onLoadActivities(LoadActivities event, Emitter<ActivityState> emit) async {
    emit(AcitvityLoading());
    try {
      final querySnapshot = await _firebaseFirestore.collection('group').doc(event.groupId).collection('activities').orderBy('create_at', descending: true).get();

      final activities = querySnapshot.docs.map((doc)=>{
        'id': doc.id,
        'name':doc['name'],
        'description':doc['description'],
        'startTime':(doc['startTime'] as Timestamp).toDate(),
        'frequency': doc['frequency'],
      }).toList();

      emit(ActivityLoaded(activities));
    } catch(e){
      emit(ActivityError('Failed to load activities'));
    }
  }

  FutureOr<void> _onDeleteActivity(DeleteActivity event, Emitter<ActivityState> emit) async {
    emit(AcitvityLoading());
    try {
      await _firebaseFirestore.collection('group').doc(event.groupId).collection('activities').doc(event.activityId).delete();
      add(LoadActivities(groupId: event.groupId));
    } catch (e){
      emit(ActivityError('Failed to delete activity'));
    }
  }
}
