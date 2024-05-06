import "package:flutter/material.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";

class ButtonSecondary extends StatelessWidget {
  static const defaultColor = OverviewPage.appBarColor;

  final VoidCallback? onPressed;
  final Color color;
  final String label;

  const ButtonSecondary({
    super.key,
    this.onPressed,
    this.color = defaultColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: OverviewPage.appBarColor,
        side: const BorderSide(color: OverviewPage.appBarColor),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: ButtonPrimary.textSize,
        ),
      ),
    );
  }
}
