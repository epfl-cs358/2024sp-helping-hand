import "package:flutter/material.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/view/pages/setup/device_setup_dialog.dart";

class UnconfiguredRemoteDevice extends StatelessWidget {
  static const defaultRemoteName = "Unnamed Remote";

  final RemoteDevice device;
  final int? index;

  const UnconfiguredRemoteDevice({
    super.key,
    required this.device,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final suffix = index == null ? "" : " ${index! + 1}";
    final name = Text("$defaultRemoteName$suffix");

    final configure = FilledButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Configure New Device"),
            content: DeviceSetupDialog(
              device: device,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
      child: const Text("Configure"),
    );

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            name,
            const SizedBox(width: 6),
            configure,
          ],
        ),
      ),
    );
  }
}
