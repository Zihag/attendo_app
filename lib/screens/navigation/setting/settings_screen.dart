import 'package:attendo_app/app_blocs/user/bloc/user_bloc.dart';
import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:attendo_app/services/FCMTokenService.dart';
import 'package:attendo_app/widgets/choice_button.dart';
import 'package:attendo_app/widgets/circle_avatar.dart';
import 'package:attendo_app/widgets/my_button.dart';
import 'package:attendo_app/widgets/setting_screen/setting_container.dart';
import 'package:card_loading/card_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              CustomCircleAvatar(
                  width: 80,
                  height: 80,
                  photoURL: user!.photoURL ??
                      'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg'),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoaded) {
                    return Column(
                      children: [
                        Text(
                          state.username,
                          style: GoogleFonts.openSans(
                              fontSize: 24, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          state.email,
                          style: GoogleFonts.openSans(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  } else if (state is UserLoading) {
                    return CardLoading(
                      height: 60,
                      borderRadius: BorderRadius.circular(10),
                      width: 200,
                    );
                  } else if (state is UserError) {
                    return Text(state.error);
                  }
                  return const Text('User not found');
                },
              ),
              SizedBox(
                height: 30,
              ),
              ChoiceButton(
                text: "Edit profile",
                color: Colors.black,
                textColor: Colors.white,
                width: 150,
                height: 50,
              ),
              SizedBox(
                height: 30,
              ),
              SettingContainer(
                functions: [
                  {
                    'icon': 'assets/vector/nofi_icon.svg',
                    'title': "Edit Profile",
                    'onTap': () {
                      print("Edit Profile tapped");
                    },
                  },
                  {
                    'icon': 'assets/vector/nofi_icon.svg',
                    'title': "Notifications",
                    'onTap': () {
                      print("Notifications tapped");
                    },
                  },
                  {
                    'icon': 'assets/vector/language_icon.svg',
                    'title': "Language",
                    'onTap': () {
                      print("Language tapped");
                    },
                  },
                  {
                    'icon': 'assets/vector/about_icon.svg',
                    'title': "About",
                    'onTap': () {
                      print("Sign Out tapped");
                    },
                  },
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ChoiceButton(
                  text: 'Sign out',
                  height: 50,
                  width: 300,
                  color: Colors.black,
                  textColor: Colors.white,
                  onTap: () async {
                    bool confirmSignOut = await _showSignOutDialog(context);
                    if (confirmSignOut) {
                      await FCMTokenService()
                          .removeUserTokenFromFirestore(user.uid);
                      await _googleSignIn.signOut();
                      print('Google Sign out');
                      await FirebaseAuth.instance.signOut();
                      print('Firebase sign out');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> _showSignOutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            content: SizedBox(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Log out of your account?',
                      style: GoogleFonts.openSans(
                          fontSize: 20, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Stack(children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Log out',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 42, // Đặt Divider xuống dưới chút
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  ]),

                  InkWell(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false; // Trả về false nếu dialog bị đóng mà không chọn
  }
}
