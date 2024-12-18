part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String username;
  final String password;

  SignUpEvent(this.email, this.password, this.username);
}

class GoogleSignInEvent extends AuthEvent {}


