import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function()? onTap;
  final String emojiText;

  const OptionButton({
    super.key,
    required this.emojiText,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).colorScheme.secondary : null,
            side: BorderSide(
              color: isSelected ? Theme.of(context).colorScheme.inversePrimary : Colors.grey,
              width: isSelected ? 3 : 1
            ),
            foregroundColor: isSelected ? Theme.of(context).colorScheme.inversePrimary : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),
            elevation: 10, // Apply elevation only when selected
          ),
          child: Row(
              children: [
                Text(
                  emojiText,
                  style: const TextStyle(
                  fontSize: 40,
                ),
                ),
                const SizedBox(width: 75),
                Text(text,
                  style:  GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color:Colors.black,
                  ),
                ),
            ]
          )
      ),
    );
  }
}
