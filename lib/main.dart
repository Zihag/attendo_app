import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/auth/bloc/auth_bloc.dart';
import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/app_blocs/link_invite/bloc/invite_bloc.dart';
import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAtxrh0b0F53TUnDKebBJmXDsll1nBII5g",
    appId: "1:939882538884:android:b63034a8424e9a1e745fd1",
    messagingSenderId: "939882538884",
    projectId: "attendoapp-8509f",
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            create: (context) =>
                AuthBloc(FirebaseAuth.instance, FirebaseFirestore.instance)),
        BlocProvider(
            create: (context) => ActivityBloc(FirebaseFirestore.instance)),
      ],
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
