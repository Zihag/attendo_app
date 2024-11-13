import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final FirebaseFirestore _firebaseFirestore;
  InvitationBloc(this._firebaseFirestore) : super(InvitationInitial()) {
    on<LoadInvitations>(_onLoadInvitations);
    on<AcceptInvitation>(_onAcceptInvitation);
    on<RejectInvitation>(_onRejectInvitation);
  }

  FutureOr<void> _onLoadInvitations(
      LoadInvitations event, Emitter<InvitationState> emit) async {
    emit(InvitationLoading());
    try {
      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

      if (userEmail.isEmpty) {
        emit(InvitationError('User not authenticated'));
        return;
      }

      print('User email: $userEmail');
      final querySnapshot = await _firebaseFirestore
          .collection('invitations')
          .where('email', isEqualTo: userEmail)
          .where('status', isEqualTo: 'pending')
          .get();

      final invitations = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'inviterId': doc['inviterId'],
                'groupId': doc['groupId'],
                'email': doc['email'],
                'status': doc['status']
              })
          .toList();

      emit(InvitationLoaded(invitations));
      print('Invitations: $invitations');
    } catch (e) {
      emit(InvitationError('Failed to load invitations'));
    }
  }

  FutureOr<void> _onAcceptInvitation(
      AcceptInvitation event, Emitter<InvitationState> emit) async {
    emit(InvitationLoading());
    try {
      await _firebaseFirestore
          .collection('invitations')
          .doc(event.invitationId)
          .update({'status': 'accepted'});

      final invitationDoc = await _firebaseFirestore
          .collection('invitations')
          .doc(event.invitationId)
          .get();

      if (invitationDoc.exists) {
        final groupId = invitationDoc['groupId'];
        final email = invitationDoc['email'];

        final userQuerySnapshot = await _firebaseFirestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userId = userQuerySnapshot.docs.first.id;

          await _firebaseFirestore.collection('groups').doc(groupId).update({
            'member': FieldValue.arrayUnion([
              {"userId": userId}
            ])
          });
        }
      }

      emit(InvitationAccepted(event.invitationId));
      add(LoadInvitations());
    } catch (e) {
      emit(InvitationError('Failed to accept invitation'));
    }
  }

  FutureOr<void> _onRejectInvitation(
      RejectInvitation event, Emitter<InvitationState> emit) async {
    emit(InvitationLoading());
    try {
      await _firebaseFirestore
          .collection('invitations')
          .doc(event.invitationId)
          .update({'status': 'rejected'});

      emit(InvitationRejected(event.invitationId));
      add(LoadInvitations());
    } catch (e) {
      emit(InvitationError('Failed to reject invitation'));
    }
  }
}
