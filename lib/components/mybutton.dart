
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String text;

  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            foregroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
          ),
          child: Text(text,
            style:  GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          )
      ),
    );
  }
}
