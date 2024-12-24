import 'package:attendo_app/app_blocs/auth/bloc/auth_bloc.dart';
import 'package:attendo_app/screens/authentication/signup_screen.dart';
import 'package:attendo_app/screens/authentication/verify_email_screen.dart';
import 'package:attendo_app/screens/main_screen.dart';
import 'package:attendo_app/widgets/my_button.dart';
import 'package:attendo_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final RoundedLoadingButtonController _facebookBtnController =
      RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GoogleSignInLoading) {
            _googleBtnController.start();
          } else if (state is GoogleAuthAuthenticated) {
            _googleBtnController.success();
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            });
          } else if (state is GoogleSignInError) {
            _googleBtnController.reset();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthLoading) {
          } else if (state is AuthSignInSuccess) {
            User? user = FirebaseAuth.instance.currentUser;

            if (user != null && !user.emailVerified) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            }
          } else if (state is AuthSignInError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Image.asset('assets/images/icon.png',fit: BoxFit.fill,height: 150,),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Sign in",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back you\'ve been missed!",
                        style: TextStyle(color: Colors.grey[700]),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  hintText: 'Email',
                  obscureText: false,
                  controller: _emailController,
                  autoFocus: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  hintText: 'Password',
                  obscureText: _isObscured,
                  controller: _passwordController,
                  autoFocus: false,
                  suffixIcon:
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                  onSuffixIconPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                        onTap: () {
                          context.read<AuthBloc>().add(SignInEvent(
                              _emailController.text, _passwordController.text));
                        },
                        text: 'Sign in',
                      ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedLoadingButton(
                      controller: _googleBtnController,
                      onPressed: () {
                        context.read<AuthBloc>().add(GoogleSignInEvent());
                      },
                      color: Colors.grey[200],
                      successColor: Colors.grey[200],
                      width: 80,
                      height: 80,
                      valueColor: Colors.black,
                      borderRadius: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RoundedLoadingButton(
                      controller: _facebookBtnController,
                      onPressed: ()  {
                        _facebookBtnController.start();
                         Future.delayed(Duration(seconds: 2), () {
                          _facebookBtnController.success();
                        });
                      },
                      color: Colors.grey[200],
                      successColor: Colors.grey[200],
                      width: 80,
                      height: 80,
                      valueColor: Colors.black,
                      borderRadius: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/facebook_logo.png',
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        // Điều hướng tới trang đăng ký tài khoản
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
