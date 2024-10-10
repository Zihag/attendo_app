import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final FirebaseFirestore _firebaseFirestore;
  InviteBloc(this._firebaseFirestore) : super(InviteInitial()) {
    on<CreateInviteLink>((event,emit) async {
      emit(InviteLoading());
      try {
        final inviteLink = 'https://attendo.com/invite?groupId=${event.groupId}';
        emit(InviteLinkCreated(inviteLink));
      } catch(e){
        emit(InviteError('Failed to create invite link'));
      }
    });
    on<SendInviteByEmail>((event,emit) async {
      emit(InviteLoading());
      try {
        final userSnapshot = await _firebaseFirestore.collection('users').where('email', isEqualTo: event.email).get();
        if(userSnapshot.docs.isNotEmpty){
          await _firebaseFirestore.collection('invitations').add({
            'groupId':event.groupId,
            'email':event.email,
            'status': 'pending',
          });
          emit(InviteSentSuccess());
        } else {
          emit(InviteError('User not found'));
        }
      } catch(e){
        emit(InviteError('Failed to send invite by email'));
      }
    });
  }

  Future<void> sendEmailInvitation(String groupId, String email) async {
    
  }
}
