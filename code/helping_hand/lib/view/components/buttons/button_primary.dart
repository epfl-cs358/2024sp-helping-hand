import "package:flutter/material.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";

class ButtonPrimary extends StatelessWidget {
  static const defaultBackgroundColor = OverviewPage.appBarColor;
  static const textSize = 14.0;

  final VoidCallback? onPressed;
  final Color backgroundColor;
  final String label;

  const ButtonPrimary({
    super.key,
    this.onPressed,
    this.backgroundColor = defaultBackgroundColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: textSize,
        ),
      ),
    );
  }
}
