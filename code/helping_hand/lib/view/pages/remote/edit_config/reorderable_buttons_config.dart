import "package:flutter/material.dart";
import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/view/components/change_string_dialog.dart";

class ReorderableButtonsCofig extends StatelessWidget {
  final List<Button> buttons;
  final void Function(List<Button> buttons) updateConfig;

  const ReorderableButtonsCofig({
    super.key,
    required this.buttons,
    required this.updateConfig,
  });

  @override
  Widget build(BuildContext context) {
    onReorder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final button = buttons.removeAt(oldIndex);
      buttons.insert(newIndex, button);
      updateConfig(buttons);
    }

    onDelete(int index) {
      buttons.removeAt(index);
      updateConfig(buttons);
    }

    onRename(int index) {
      showDialog(
        context: context,
        builder: (context) => ChangeStringDialog(
          title: "Change Button Label",
          defaultValue: buttons[index].label,
          onConfirm: (newLabel) {
            final button = buttons.removeAt(index).withArgs(label: newLabel);
            buttons.insert(index, button);
            updateConfig(buttons);
          },
        ),
      );
    }

    final buttonsList = [
      for (final (i, button) in buttons.indexed)
        ListTile(
          key: UniqueKey(),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onDelete(i),
                icon: const Icon(Icons.delete),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () => onRename(i),
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          title: Text(button.label),
        ),
    ];

    return ReorderableListView(
      onReorder: onReorder,
      children: buttonsList,
    );
  }
}
