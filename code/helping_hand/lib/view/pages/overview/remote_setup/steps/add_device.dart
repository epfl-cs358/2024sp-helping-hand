import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/components/input_text.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class AddDevice extends HookConsumerWidget {
  final RemoteDevice remote;
  final RemoteConfiguration config;

  const AddDevice({
    super.key,
    required this.remote,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();

    final nameField = InputText(
      controller: nameController,
      label: "Device Name",
    );

    save() {
      final savedRemote = SavedRemote(
        name: nameController.text,
        config: config,
        device: remote,
        isOnline: true,
      );

      ref.read(SavedRemotesNotifier.provider.notifier).setRemote(savedRemote);

      Navigator.pop(context);
    }

    final saveButton = ButtonPrimary(
      onPressed: save,
      label: "Save Device",
    );

    return Column(
      children: [
        nameField,
        const SizedBox(height: 10),
        saveButton,
      ],
    );
  }
}
