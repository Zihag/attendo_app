import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore _firebaseFirestore;
  UserBloc(this._firebaseFirestore) : super(UserInitial()) {
    on<FetchUserData>(_onFetchUserData);
  }

  FutureOr<void> _onFetchUserData(FetchUserData event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userDoc = await _firebaseFirestore.collection('users').doc(event.userId).get();
      if(userDoc.exists){
        emit(UserLoaded(userDoc.data()!));
      } else {
        emit(UserError('User not found'));
      }
    } catch (e) {
      emit(UserError('Failed to fetch user data'));
    }
  }
}
