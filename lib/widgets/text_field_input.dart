import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType type;
  final bool isPass;
  final String hintText;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      required this.type,
      required this.isPass,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: textEditingController,
        keyboardType: type,
        obscureText: isPass,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none
          ),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 18),
            border: OutlineInputBorder(
                borderSide: Divider.createBorderSide(context)),
            enabledBorder: OutlineInputBorder(
                borderSide: Divider.createBorderSide(context)),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8)));
  }
}
