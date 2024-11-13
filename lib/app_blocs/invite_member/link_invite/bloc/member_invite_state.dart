part of 'member_invite_bloc.dart';

@immutable
sealed class MemberInviteState {}

final class MemberInviteInitial extends MemberInviteState {}

class MemberInviteLoading extends MemberInviteState {}

class InviteLinkCreated extends MemberInviteState {
  final String inviteLink;

  InviteLinkCreated(this.inviteLink);
}

class MemberInviteSentSuccess extends MemberInviteState {}

class MemberInviteError extends MemberInviteState {
  final String error;

  MemberInviteError(this.error);
}
