import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String photoURL;
  const CustomCircleAvatar({super.key, required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ]
      ),
      
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundImage: NetworkImage(photoURL),
          radius: 23,
        ),
        radius: 27,
      ),
    );
  }
}