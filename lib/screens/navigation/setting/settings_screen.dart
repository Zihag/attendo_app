import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:attendo_app/services/FCMTokenService.dart';
import 'package:attendo_app/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;
   SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ListView(
            children: [

            ],
          )),
          Padding(padding: 
          const EdgeInsets.symmetric(vertical: 100),
          child: MyButton(text: 'Sign out',
      height: 100,
      onTap: () async {
        bool confirmSignOut = await _showSignOutDialog(context);
        if(confirmSignOut){
          await FCMTokenService().removeUserTokenFromFirestore(user!.uid);
          await _googleSignIn.signOut();
          print('Google Sign out');
          await FirebaseAuth.instance.signOut();
          print('Firebase sign out');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        }
      },
      ),),
          
        ],
      )
    );
  }

  Future<bool> _showSignOutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Sign Out'),
            content: Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Người dùng hủy, không đăng xuất
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Người dùng xác nhận, đăng xuất
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ) ??
        false; // Trả về false nếu dialog bị đóng mà không chọn
  }
}