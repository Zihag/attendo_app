import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/activity_choice/bloc/activity_choice_bloc.dart';
import 'package:attendo_app/app_blocs/auth/bloc/auth_bloc.dart';
import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/app_blocs/invite_member/invitation/bloc/invitation_bloc.dart';
import 'package:attendo_app/app_blocs/invite_member/link_invite/bloc/member_invite_bloc.dart';
import 'package:attendo_app/app_blocs/today_activity/bloc/today_activity_bloc.dart';
import 'package:attendo_app/app_blocs/user/bloc/user_bloc.dart';
import 'package:attendo_app/screens/splash/splash_screen.dart';
import 'package:attendo_app/services/FCMTokenService.dart';
import 'package:attendo_app/services/attendance_service.dart';
import 'package:attendo_app/services/today_activity_service.dart';
import 'package:attendo_app/services/username_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    
  ));
  final todayActivityService = TodayActivityService(FirebaseFirestore.instance);
  final usernameService = UsernameService(FirebaseFirestore.instance);
  final attendanceService = AttendanceService();
  final fcmTokenService = FCMTokenService();
  runApp(MyApp(
    todayActivityService: todayActivityService,
    usernameService: usernameService,
    attendanceService: attendanceService,
    fcmTokenService: fcmTokenService,
  ));
}

class MyApp extends StatelessWidget {
  final TodayActivityService todayActivityService;
  final UsernameService usernameService;
  final AttendanceService attendanceService;
  final FCMTokenService fcmTokenService;

  const MyApp(
      {super.key,
      required this.todayActivityService,
      required this.usernameService,
      required this.attendanceService,
      required this.fcmTokenService});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GroupBloc(FirebaseFirestore.instance)..add(LoadGroups()),
        ),
        BlocProvider(
          create: (context) => MemberInviteBloc(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => AuthBloc(FirebaseAuth.instance,
              FirebaseFirestore.instance, usernameService, fcmTokenService),
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
        BlocProvider(create: (context) => UserBloc(FirebaseFirestore.instance)),
        BlocProvider(
          create: (context) {
            print('Initializing InvitationBloc');
            return InvitationBloc(FirebaseFirestore.instance)
              ..add(LoadInvitations());
          },
        ),
        // BlocProvider(create: (context) => ActivityChoiceBloc(attendanceService)),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
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
