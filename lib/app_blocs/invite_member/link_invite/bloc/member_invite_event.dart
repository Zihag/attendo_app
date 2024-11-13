part of 'member_invite_bloc.dart';

@immutable
sealed class MemberInviteEvent {}

class CreateInviteLink extends MemberInviteEvent {
  final String groupId;

  CreateInviteLink(this.groupId);
}

class SendInviteByEmail extends MemberInviteEvent {
  final String groupId;
  final String email;

  SendInviteByEmail(this.groupId, this.email);
}