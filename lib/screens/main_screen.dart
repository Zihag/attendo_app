import 'package:attendo_app/screens/navigation/activity/activity_screen.dart';
import 'package:attendo_app/screens/navigation/home/home_screen.dart';
import 'package:attendo_app/screens/navigation/notify/notification_screen.dart';
import 'package:attendo_app/screens/navigation/profile/profile_screen.dart';
import 'package:attendo_app/screens/navigation/setting/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    ActivityScreen(),
    NotificationScreen(),
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.green[100]!,
        items: [
          Icon(Icons.timer),
          Icon(Icons.notifications),
          Icon(Icons.home),
          Icon(Icons.person_4_rounded),
          Icon(Icons.settings),
        ],
        onTap: _onItemTapped,
        index: 2,
        animationDuration: Duration(milliseconds: 300),height: 60.0,
      ),
    );
  }
}


