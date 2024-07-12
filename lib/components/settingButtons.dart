import 'package:flutter/material.dart';

class settingButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  final void Function()? onTap;

  const settingButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      // padding: const EdgeInsets.symmetric(horizontal: 25),
      child: OutlinedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black12,
            elevation: 10,
            side: const BorderSide(color: Colors.black12, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                text,
                style: textStyle
              ),
              const Spacer(),
              const Text(
                ">",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
              ),
            ],
          )),
    );
  }
}
