import 'package:attendo_app/group/bloc/group_bloc.dart';
import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc(FirebaseFirestore.instance)..add(LoadGroups()),
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
