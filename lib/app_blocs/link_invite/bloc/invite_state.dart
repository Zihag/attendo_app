part of 'invite_bloc.dart';

@immutable
sealed class InviteState {}

final class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteLinkCreated extends InviteState {
  final String inviteLink;

  InviteLinkCreated(this.inviteLink);
}

class InviteSentSuccess extends InviteState {}

class InviteError extends InviteState {
  final String error;

  InviteError(this.error);
}
