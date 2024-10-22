part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class FetchUserData extends UserEvent {
  final String userId;

  FetchUserData(this.userId);
}