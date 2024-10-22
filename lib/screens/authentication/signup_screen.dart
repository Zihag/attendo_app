import 'package:attendo_app/app_blocs/auth/bloc/auth_bloc.dart';
import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:attendo_app/screens/navigation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Sign up successful. A verification email has been sent. Please verify you email before logging in')));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if (state is AuthSignUpError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
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
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if(state is AuthLoading){
                  return CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                      onPressed: (){
                        context.read<AuthBloc>().add(SignUpEvent(_emailController.text, _passwordController.text));
                      },
                      child: Text("Sign Up"),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
