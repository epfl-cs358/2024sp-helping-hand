import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/components/input_text.dart";

class ChangeStringDialog extends HookWidget {
  final String title;
  final String defaultValue;
  final void Function(String newValue) onConfirm;
  final bool multiline;

  const ChangeStringDialog({
    super.key,
    required this.title,
    required this.defaultValue,
    required this.onConfirm,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: defaultValue);

    return AlertDialog(
      title: Text(title),
      content: InputText(
        controller: controller,
        maxLines: multiline ? null : 1,
        autofocus: true,
      ),
      actions: [
        ButtonPrimary(
          onPressed: () {
            onConfirm(controller.text);
            Navigator.pop(context);
          },
          label: "Confirm",
        ),
      ],
    );
  }
}
