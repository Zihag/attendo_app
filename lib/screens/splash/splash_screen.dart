import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:attendo_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyan,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/Lottie/splash.json",
              height: 300,
              repeat: false,
            ),
          )
        ],
      ),
    );
  }

  void _checkUser() async {
    await Future.delayed(const Duration(seconds: 4));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
