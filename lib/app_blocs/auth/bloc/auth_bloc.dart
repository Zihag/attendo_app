import 'dart:async';

import 'package:attendo_app/services/FCMTokenService.dart';
import 'package:attendo_app/services/username_generator.dart';
import 'package:attendo_app/services/username_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final UsernameService _usernameService;
  final FCMTokenService _fcmTokenService;
  AuthBloc(this._firebaseAuth, this._firebaseFirestore, this._usernameService,
      this._fcmTokenService)
      : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<GoogleSignInEvent>(_onGoogleSignIn);
  }

  FutureOr<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: event.email, password: event.password);

      final user = userCredential.user;

      //save FCM Token, listen for the change of token
      await _fcmTokenService.saveUserTokenToFirestore(user!.uid);
      _fcmTokenService.setupTokenRefresh(user.uid);


      // if (userCredential.user?.emailVerified == true) {
      emit(AuthSignInSuccess());
      // } else {
      //   emit(AuthSignInError('Please verify your email before logging in'));
      // }

    } on FirebaseAuthException catch (e) {
      print('LOGIN ERROR: ' + e.toString());
      switch (e.code) {
        case 'invalid-credential':
          emit(AuthSignInError('Email or password are incorrect'));
          break;
        case 'invalid-email':
          emit(AuthSignInError('Invalid email'));
          break;
        case 'channel-error':
          emit(AuthSignInError('Please enter email and password'));
          break;
        default:
          emit(AuthSignInError('An error occurred. Please try again'));
          break;
      }
    } catch (e) {
      emit(AuthSignInError('An unkown error occurred'));
    }
  }

  FutureOr<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      bool isUsernameExisted =
          await _usernameService.isUsernameTaken(event.username);
      if (isUsernameExisted) {
        emit(AuthSignInError('Username already existed'));
        return;
      }
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
      await userCredential.user?.sendEmailVerification();
      if (userCredential.user != null) {
        await _createUserInFireStore(userCredential.user!, event.username);
      }
      emit(AuthSignUpSuccess());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(AuthSignUpError(
              'This email is already registered. Please log in.'));
          break;
        case 'invalid-email':
          emit(AuthSignUpError('Invalid email'));
          break;
        case 'weak-password':
          emit(AuthSignUpError(
              'Password must be a string with at least six characters'));
          break;
        default:
          emit(AuthSignUpError('An error occurred. Please try again'));
          break;
      }
    } catch (e) {
      print('Unknown sign up error: ' + e.toString());
      emit(AuthSignUpError('An unknown error occurred'));
    }
  }

  FutureOr<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(GoogleSignInLoading());
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(GoogleSignInError('Google Sign-In was cancelled'));
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);
      User? user = userCredential.user;
      if (user != null) {
        //create random username
        final baseName =
            user.displayName ?? user.email?.split('@')[0] ?? 'user';
        final username = await UsernameGenerator().generateUsername(baseName);

        await _createUserInFireStore(user, username);

        //save FCM Token, listen for the change of token
        await _fcmTokenService.saveUserTokenToFirestore(user.uid);

        _fcmTokenService.setupTokenRefresh(user.uid);
      }
      await _firebaseAuth.signInWithCredential(authCredential);

      emit(GoogleAuthAuthenticated());
    } catch (e) {
      emit(GoogleSignInError(e.toString()));
    }
  }

  Future<void> _createUserInFireStore(User user, String username) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userRef.set(({
      'uid': user.uid,
      'email': user.email,
      'username': username,
      'created_at': FieldValue.serverTimestamp(),
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'phoneNumber': user.phoneNumber,
    }));
  }


}
