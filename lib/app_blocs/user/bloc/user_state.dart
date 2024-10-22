part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoading extends UserState{}

class UserLoaded extends UserState {
  final Map<String, dynamic> userData;

  UserLoaded(this.userData);
}

class UserError extends UserState{
  final String error;

  UserError(this.error);
}
