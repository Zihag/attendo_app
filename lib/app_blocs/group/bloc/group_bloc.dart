import 'dart:async';

import 'package:attendo_app/services/today_activity_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final FirebaseFirestore _firestore;
  GroupBloc(this._firestore) : super(GroupInitial()) {
    on<CreateGroup>(_onCreateGroup);
    on<LoadGroups>(_onLoadGroups);
    on<DeleteGroup>(_onDeleteGroup);
  }

  FutureOr<void> _onCreateGroup(CreateGroup event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if(user == null){
        emit(GroupError('User not logged in'));
        return;
      }
      await _firestore.collection('groups').add({
        'name':event.groupName,
        'description':event.groupDescription,
        'member':[{
          'userId': user.uid,
        }],
        'adminId':user.uid,
        'create_at':FieldValue.serverTimestamp(),
      });
      add(LoadGroups());
    } catch (e){
      emit(GroupError("Failed to create group"));
    }
  }

  FutureOr<void> _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      String userId = await FirebaseAuth.instance.currentUser?.uid??'';
      print(userId);
      final querySnapshot = await _firestore.collection('groups').where('member',arrayContains: {'userId':userId}).get();
      final groups = querySnapshot.docs.map((doc) => {
        'id': doc.id,
        'name':doc['name'],
        'description':doc['description'],
        'member':doc['member'],
      }).toList();
      print('Groups: $groups');
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError("Failed to load groups"));
    }
  }

  FutureOr<void> _onDeleteGroup(DeleteGroup event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try{
      await _firestore.collection('groups').doc(event.groupId).delete();
      add(LoadGroups());
    } catch(e){
      emit(GroupError("Failed to delete group"));
    }
  }

  
}
