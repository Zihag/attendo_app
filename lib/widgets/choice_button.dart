import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? height;
  final Color color;
  const ChoiceButton({super.key, this.onTap, required this.text, this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}