import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/device.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class AddDevice extends HookConsumerWidget {
  final String config;
  final RemoteDevice device;

  const AddDevice({
    super.key,
    required this.config,
    required this.device,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            label: Text("Device Name"),
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO save device state logic
            Navigator.pop(context);
          },
          child: const Text("Save Device"),
        )
      ],
    );
  }
}
