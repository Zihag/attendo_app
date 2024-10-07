import 'package:attendo_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Hàm đăng ký tài khoản Firebase Authentication
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Hiển thị vòng xoay khi đang đăng ký
    });

    try {
      // Thực hiện đăng ký tài khoản mới với Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Gửi email xác minh
      await userCredential.user?.sendEmailVerification();

      // Hiển thị thông báo yêu cầu xác minh email
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Sign up successful. A verification email has been sent. Please verify your email before logging in.'),
      ));
      // Đăng ký thành công, hiển thị thông báo và quay về trang đăng nhập
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign up successful. Please log in.'),
      ));

      // Điều hướng về màn hình đăng nhập
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      print(e.toString());
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered. Please log in.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email';
          break;
        case 'weak-password':
          errorMessage =
              'Password must be a string with at least six characters';
          break;
        default:
          errorMessage = 'An error occurred. Please try again';
      }
      // Hiển thị thông báo lỗi khi đăng ký thất bại
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Tắt vòng xoay sau khi kết thúc quá trình
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
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
                    onPressed: _signUp,
                    child: Text("Sign Up"),
                  ),
          ],
        ),
      ),
    );
  }
}
