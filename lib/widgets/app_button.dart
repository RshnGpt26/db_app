import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.icon, this.text, required this.onPressed});

  final IconData? icon;
  final String? text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 53, 51, 51),
          borderRadius: BorderRadius.circular(8),
        ),
        padding:
            text != null
                ? EdgeInsets.symmetric(horizontal: 15, vertical: 8)
                : EdgeInsets.all(8),
        child:
            icon != null
                ? Icon(icon, color: Colors.white, size: 22)
                : text != null
                ? Text(
                  text ?? "",
                  style: Theme.of(context).textTheme.labelMedium,
                )
                : null,
      ),
    );
  }
}
