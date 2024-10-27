import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SquareRoundedLoadingButton extends StatelessWidget {
  final RoundedLoadingButtonController controller;
  final Function()? onPressed;
  final String imagePath;
  const SquareRoundedLoadingButton(
      {super.key,
      required this.controller,
      this.onPressed,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
        controller: controller,
        onPressed: onPressed,
        width: 80,
        height: 80,
        valueColor: Colors.black,
        borderRadius: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
            )
          ],
        ));
  }
}
