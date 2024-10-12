part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

//Email password-sign in-sign up
class AuthLoading extends AuthState{}

class AuthSignInSuccess extends AuthState{}

class AuthSignUpSuccess extends AuthState{}

class AuthSignInError extends AuthState{
  final String error;

  AuthSignInError(this.error);
}

class AuthSignUpError extends AuthState{
  final String error;

  AuthSignUpError(this.error);
}

//Google-sign in
class GoogleSignInLoading extends AuthState{}

class GoogleSignInSuccess extends AuthState{}

class GoogleAuthAuthenticated extends AuthState{}

class GoogleSignInError extends AuthState{
  final String error;

  GoogleSignInError(this.error);
}
