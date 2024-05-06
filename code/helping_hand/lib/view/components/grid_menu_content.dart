import "package:flutter/material.dart";

class GridMenuContent extends StatelessWidget {
  static const maxElementWdith = 170.0;
  static const gridSpacing = 5.0;

  final List<Widget> children;

  const GridMenuContent({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final grid = GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxElementWdith,
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridSpacing,
      ),
      children: children,
    );

    return Padding(
      padding: const EdgeInsets.all(gridSpacing),
      child: grid,
    );
  }
}
