import "package:flutter/material.dart";

class ScrollBody extends StatelessWidget {
  const ScrollBody({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 14,
            bottom: 26.0,
          ),
          child: child,
        ),
      ),
    );
  }
}
