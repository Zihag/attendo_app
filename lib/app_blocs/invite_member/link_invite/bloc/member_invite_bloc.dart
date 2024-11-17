import 'package:attendo_app/services/invite_user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'member_invite_event.dart';
part 'member_invite_state.dart';

class MemberInviteBloc extends Bloc<MemberInviteEvent, MemberInviteState> {
  final FirebaseFirestore _firebaseFirestore;
  MemberInviteBloc(this._firebaseFirestore) : super(MemberInviteInitial()) {
    on<CreateInviteLink>((event, emit) async {
      emit(MemberInviteLoading());
      try {
        final inviteLink =
            'https://attendo.com/invite?groupId=${event.groupId}';
        emit(InviteLinkCreated(inviteLink));
      } catch (e) {
        emit(MemberInviteError('Failed to create invite link'));
      }
    });
    on<SendInviteByEmail>((event, emit) async {
      emit(MemberInviteLoading());
      try {
        User? user = FirebaseAuth.instance.currentUser;
        final inviteUserService = InviteUserService(FirebaseFirestore.instance);

        //check if user exists
        final userSnapshot = await _firebaseFirestore
            .collection('users')
            .where('email', isEqualTo: event.email)
            .get();

        //if exist then add uid into invitation
        if (userSnapshot.docs.isNotEmpty) {
          final userId = userSnapshot.docs.first.id;

          final isUserInGroup = await inviteUserService.checkUserInGroup(
              groupId: event.groupId, userId: userId);

          if (isUserInGroup) {
            emit(MemberInviteError("User already in group"));
          } else {
            await _firebaseFirestore.collection('invitations').add({
              'inviterId': user?.uid,
              'groupId': event.groupId,
              'email': event.email,
              'status': 'pending',
            });
            emit(MemberInviteSentSuccess());
          }
        } else {
          emit(MemberInviteError('User not found'));
        }
      } catch (e) {
        emit(MemberInviteError('Failed to send invite by email'));
      }
    });
  }

  Future<void> sendEmailInvitation(String groupId, String email) async {}
}
