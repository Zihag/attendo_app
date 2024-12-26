import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String photoURL;
  final double width;
  final double height;
  const CustomCircleAvatar({super.key, required this.photoURL, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [
          Colors.green,
          AppColors.cyan
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight)
      ),
      
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(photoURL),
              radius: 23,
            ),
          ),
        ),
      ),
    );
  }
}