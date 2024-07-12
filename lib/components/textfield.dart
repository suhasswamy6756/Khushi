import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool readOnly;
  final Color hintColor;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.readOnly,
    required this.hintColor,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate padding and font size based on screen size
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final hintFontSize = screenWidth * 0.04; // 4% of screen width

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        readOnly: readOnly,
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        validator: validator,
        decoration: decoration?.copyWith(
          hintStyle: TextStyle(color: hintColor, fontSize: hintFontSize),
        ) ?? InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, fontSize: hintFontSize),
        ),
      ),
    );
  }
}
