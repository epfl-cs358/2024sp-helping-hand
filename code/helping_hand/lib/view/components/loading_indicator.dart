import "package:flutter/material.dart";

class LoadingIndicator extends StatelessWidget {
  static const side = 40.0;

  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: side,
      height: side,
      child: CircularProgressIndicator(),
    );
  }
}
