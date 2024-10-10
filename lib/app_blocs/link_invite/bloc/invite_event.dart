part of 'invite_bloc.dart';

@immutable
sealed class InviteEvent {}

class CreateInviteLink extends InviteEvent {
  final String groupId;

  CreateInviteLink(this.groupId);
}

class SendInviteByEmail extends InviteEvent {
  final String groupId;
  final String email;

  SendInviteByEmail(this.groupId, this.email);
}