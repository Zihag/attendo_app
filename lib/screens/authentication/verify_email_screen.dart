import 'dart:async';
import 'package:attendo_app/screens/navigation/home/home_screen.dart';
import 'package:attendo_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isEmailVerified = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Kiểm tra ngay lập tức xem email đã được xác minh chưa
    _checkEmailVerified();

    // Tạo một bộ đếm thời gian để kiểm tra trạng thái xác minh mỗi 3 giây
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy bộ đếm thời gian khi thoát khỏi màn hình
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload(); // Tải lại thông tin người dùng

    if (user != null && user.emailVerified) {
      setState(() {
        _isEmailVerified = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Verify successful!')));

      // Nếu email đã xác minh, điều hướng đến MainScreen
      _timer?.cancel(); // Hủy bộ đếm thời gian
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification email resent. Please check your inbox.'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to resend verification email.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
      ),
      body: Center(
        child: _isEmailVerified
            ? CircularProgressIndicator() // Hiển thị vòng xoay khi đang chờ xác minh
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A verification email has been sent to your email. Please verify your email to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _resendVerificationEmail,
                    child: Text('Resend Verification Email'),
                  ),
                ],
              ),
      ),
    );
  }
}
