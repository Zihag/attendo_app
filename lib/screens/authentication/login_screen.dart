import 'package:attendo_app/app_blocs/auth/bloc/auth_bloc.dart';
import 'package:attendo_app/screens/navigation/home/home_screen.dart';
import 'package:attendo_app/screens/authentication/signup_screen.dart';
import 'package:attendo_app/screens/authentication/verify_email_screen.dart';
import 'package:attendo_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RoundedLoadingButtonController _googleBtnController =
      RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GoogleSignInLoading) {
            _googleBtnController.start();
          } else if (state is GoogleAuthAuthenticated) {
            _googleBtnController.success();
            Future.delayed(Duration(seconds: 1),(){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
            });
            
          } else if (state is GoogleSignInError) {
            _googleBtnController.reset();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthLoading){

          } else if (state is AuthSignInSuccess){
            User? user = FirebaseAuth.instance.currentUser;

            if(user != null && !user.emailVerified){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
            } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
            }
          } else if(state is AuthSignInError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignInEvent(
                            _emailController.text, _passwordController.text));
                      },
                      child: Text("Login"),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Điều hướng tới trang đăng ký tài khoản
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text("Don't have an account? Sign up"),
              ),
              RoundedLoadingButton(
                controller: _googleBtnController,
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleSignInEvent());
                },
                child: Text(
                  'Login with Google',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                successColor: Colors.blue,
                width: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
