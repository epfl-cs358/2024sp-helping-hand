import "package:flutter/material.dart";

class LoadingIndicator extends StatelessWidget {
  static const _side = 40.0;

  final double side;

  const LoadingIndicator({
    super.key,
    this.side = _side,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side,
      height: side,
      child: const CircularProgressIndicator(),
    );
  }
}
