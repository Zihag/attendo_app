import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      await _firestore.collection('group').add({
        'name':event.groupName,
        'description':event.groupDescription,
        'member':[],
      });
      add(LoadGroups());
    } catch (e){
      emit(GroupError("Failed to create group"));
    }
  }

  FutureOr<void> _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      final querySnapshot = await _firestore.collection('group').get();
      final groups = querySnapshot.docs.map((doc) => {
        'id': doc.id,
        'name':doc['name'],
        'description':doc['description'],
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
      await _firestore.collection('group').doc(event.groupId).delete();
      add(LoadGroups());
    } catch(e){
      emit(GroupError("Failed to delete group"));
    }
  }
}