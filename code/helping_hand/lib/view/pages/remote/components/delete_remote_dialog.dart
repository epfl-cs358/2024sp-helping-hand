import "package:flutter/material.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/components/buttons/button_secondary.dart";

class DeleteRemoteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteRemoteDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final cancelButton = ButtonSecondary(
      onPressed: Navigator.of(context).pop,
      label: "Cancel",
    );

    final confirmButton = ButtonPrimary(
      backgroundColor: Colors.red,
      onPressed: () {
        onConfirm();
        Navigator.pop(context);
      },
      label: "Delete",
    );

    return AlertDialog(
      title: const Text("Confirm Remote Deletion"),
      content: const Text(
        "Do you want to remove this remote ?\nThe associated configuration will be lost.",
      ),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );
  }
}
