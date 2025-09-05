import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50.0,
    this.width = 150.0,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor, // Text color
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius), // Rounded corners
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
