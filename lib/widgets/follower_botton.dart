import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;

  const FollowButton(
      {super.key,
      required this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextButton(
          onPressed: function,
          child: Container(
            height: 36,
            width: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
