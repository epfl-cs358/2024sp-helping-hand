import "package:flutter/material.dart";

class CardButton extends StatelessWidget {
  static const iconSize = 36.0;
  static const textSize = 16.0;
  static const textIconSpacing = 10.0;

  static const helperColor = Colors.blueGrey;

  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  const CardButton({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon!, size: iconSize),
              if (icon != null) const SizedBox(height: textIconSpacing),
              Text(
                label,
                style: const TextStyle(fontSize: textSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
