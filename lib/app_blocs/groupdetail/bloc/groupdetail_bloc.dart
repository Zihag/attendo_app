import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

part 'groupdetail_event.dart';
part 'groupdetail_state.dart';

class GroupDetailBloc extends Bloc<GroupDetailEvent, GroupDetailState> {
  final FirebaseFirestore _firebaseFirestore;
  GroupDetailBloc(this._firebaseFirestore) : super(GroupDetailInitial()) {
    on<LoadGroupDetail>(_onLoadGroupDetail);
  }

  FutureOr<void> _onLoadGroupDetail(LoadGroupDetail event, Emitter<GroupDetailState> emit) async {
    emit(GroupDetailLoading());
    try {
      final docSnapshot = await _firebaseFirestore.collection('groups').doc(event.groupid).get();
      if(docSnapshot.exists){
        emit(GroupDetailLoaded(docSnapshot.data()!));
      } else {
        emit(GroupDetailError('Group not found'));
      }
    } catch (e){
      emit(GroupDetailError('Failed to load group details'));
    }
  }
}
