import "package:flutter/material.dart";

class ScrollBody extends StatelessWidget {
  const ScrollBody({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(
      top: 14,
      bottom: 26.0,
    );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
      ],
    );

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: content,
        ),
      ),
    );
  }
}
