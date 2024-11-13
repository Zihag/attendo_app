part of 'invitation_bloc.dart';

@immutable
sealed class InvitationState {}

final class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState{}

class InvitationLoaded extends InvitationState{
  final List<Map<String, dynamic>> invitations;

  InvitationLoaded(this.invitations);
}

class InvitationError extends InvitationState {
  final String message;

  InvitationError(this.message);
}

class InvitationAccepted extends InvitationState{
  final String invitationId;

  InvitationAccepted(this.invitationId);
}

class InvitationRejected extends InvitationState {
  final String invitationId;

  InvitationRejected(this.invitationId);
}