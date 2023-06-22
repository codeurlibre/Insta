import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({Key? key, required this.onTap, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration:  BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.circular(4)

          ),
          child: Text(text, style: const TextStyle(fontSize: 20),)
      ),
    );
  }
}
