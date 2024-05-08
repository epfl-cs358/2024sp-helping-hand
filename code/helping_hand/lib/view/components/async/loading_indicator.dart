import "package:flutter/material.dart";

class LoadingIndicator extends StatelessWidget {
  static const defaultSide = 40.0;

  static const _color = Colors.white;

  const LoadingIndicator({
    super.key,
    this.side = defaultSide,
    this.color = _color,
  });

  final double side;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side,
      height: side,
      child: CircularProgressIndicator(color: color),
    );
  }
}
