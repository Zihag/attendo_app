part of 'invitation_bloc.dart';

@immutable
sealed class InvitationEvent {}

class LoadInvitations extends InvitationEvent {
}

class AcceptInvitation extends InvitationEvent {
  final String invitationId;

  AcceptInvitation(this.invitationId);
}

class RejectInvitation extends InvitationEvent {
  final String invitationId;

  RejectInvitation(this.invitationId);
}