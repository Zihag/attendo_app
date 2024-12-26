part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoading extends UserState{}

class UserLoaded extends UserState {
  final Map<String, dynamic> userData;

  UserLoaded(this.userData);

  String get displayName => userData['displayName'] ?? '';
  String get username => userData['username'] ?? 'User';
  String get email => userData['email'] ?? 'Email';
}

class UserError extends UserState{
  final String error;

  UserError(this.error);
}
