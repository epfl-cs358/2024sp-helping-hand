import "package:flutter/material.dart";
import "package:helping_hand/view/pages/remote/button_setup/button_setup_dialog.dart";

class GridActionContent extends StatelessWidget {
  static const gridSpacing = 2.0;
  static const maxGridWidth = 350.0;

  final List<Widget> children;

  const GridActionContent({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final grid = GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ButtonSetupDialog.directions.length,
        mainAxisSpacing: gridSpacing,
        crossAxisSpacing: gridSpacing,
      ),
      shrinkWrap: true,
      children: children,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: maxGridWidth),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      child: grid,
    );
  }
}
