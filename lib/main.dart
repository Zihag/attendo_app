import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/auth/bloc/auth_bloc.dart';
import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/app_blocs/link_invite/bloc/invite_bloc.dart';
import 'package:attendo_app/app_blocs/today_activity/bloc/today_activity_bloc.dart';
import 'package:attendo_app/app_blocs/user/bloc/user_bloc.dart';
import 'package:attendo_app/screens/splash/splash_screen.dart';
import 'package:attendo_app/services/today_activity_service.dart';
import 'package:attendo_app/services/username_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAtxrh0b0F53TUnDKebBJmXDsll1nBII5g",
    appId: "1:939882538884:android:b63034a8424e9a1e745fd1",
    messagingSenderId: "939882538884",
    projectId: "attendoapp-8509f",
  ));
  final todayActivityService = TodayActivityService(FirebaseFirestore.instance);
  final usernameService = UsernameService(FirebaseFirestore.instance);
  runApp(MyApp(
    todayActivityService: todayActivityService,
    usernameService: usernameService,
  ));
}

class MyApp extends StatelessWidget {
  final TodayActivityService todayActivityService;
  final UsernameService usernameService;

  const MyApp(
      {super.key,
      required this.todayActivityService,
      required this.usernameService});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GroupBloc(FirebaseFirestore.instance)..add(LoadGroups()),
        ),
        BlocProvider(
          create: (context) => InviteBloc(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => AuthBloc(FirebaseAuth.instance,
              FirebaseFirestore.instance, usernameService),
        ),
        BlocProvider(
          create: (context) => ActivityBloc(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => TodayActivityBloc(todayActivityService)
            ..add(
              LoadTodayActivities(),
            ),
        ),
        BlocProvider(create: (context) => UserBloc(FirebaseFirestore.instance))
      ],
      child: MaterialApp(
        home: SplashScreen(),
        theme: _buildTheme(Brightness.light),
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme =
      ThemeData(brightness: brightness, colorSchemeSeed: Colors.cyan);

  return baseTheme.copyWith(
      textTheme: GoogleFonts.openSansTextTheme(baseTheme.textTheme));
}
