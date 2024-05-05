import "package:flutter/material.dart";

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    final okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Ok"),
    );

    return AlertDialog(
      title: const Text("Error Occurred"),
      content: Text(error),
      actions: [
        okButton,
      ],
    );
  }
}
